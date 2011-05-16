//
// Steven Shaw adapted from original NeHe tutorials. See original notice below.
//

/*
 * ORIGINAL NOTICE:
 *
 * This code was created by Jeff Molofee '99
 * (ported to Linux/SDL by Ti Leggett '01)
 *
 * If you've found this code useful, please let me know.
 *
 * Visit Jeff at http://nehe.gamedev.net/
 * 
 * or for port-specific comments, questions, bugreports etc. 
 * email to leggett@eecs.tulane.edu
 */

#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <OpenGL/gl.h>
#include <OpenGL/glu.h>
#include <SDL/SDL.h>

#define loop(v, m) for(int v = 0; v < (m); ++v)
#define loopi(m) loop(i, m)
#define loopj(m) loop(j, m)
#define loopk(m) loop(k, m)
#define loopl(m) loop(l, m)

#define SCREEN_WIDTH  640
#define SCREEN_HEIGHT 480
#define SCREEN_BPP     16

static SDL_Surface *surface;

static GLfloat yRot = 0.0f; // Camera rotation.
static GLfloat xPos, zPos;  // Camera position.

static GLfloat lightAmbient[]  = { 0.5f, 0.5f, 0.5f, 1.0f };
static GLfloat lightDiffuse[]  = { 1.0f, 1.0f, 1.0f, 1.0f };
static GLfloat lightPosition[] = { 0.0f, 0.0f, 2.0f, 1.0f };

static GLuint textureType = 0;
static GLuint texture[3];

static bool lighting = false;
static bool blending = false;

struct Vertex {
  GLfloat x, y, z; // 3D coords.
  GLfloat u, v;    // Tex coords.
};

struct Triangle {
  Vertex vertex[3];
};

struct Sector {
  int numTriangles;
  Triangle *triangle; // Array of triangles
};

static Sector sector1 = {0, NULL};

// Used for converting to radians.
const float piover180 = 0.0174532925f;

// Head "bobbing".
static GLfloat walkBias = 0.0f;
static GLfloat walkBiasAngle = 0.0f;

static GLfloat lookupdown = 0.0f;

static int videoFlags  = SDL_OPENGL;

const char *worldFile = "data/world.txt";

static void readString(FILE *file, char string[]) {
  do {
    fgets(string, 255, file);
  } while ((string[0] == '/') || (string[0] == '\n'));           
}

void loadWorld() {
  FILE *in = fopen(worldFile, "rt");
  
  char line[256];
  readString(in, line);
  
  int numTriangles;
  int n = sscanf(line, "NUMPOLLIES %d\n", &numTriangles);
  printf("sscanf NUMPOLLIES => %d\n", n);
  printf("numTriangles = %i\n", numTriangles);
  
  sector1.numTriangles = numTriangles;
  sector1.triangle = new Triangle[numTriangles];
  
  loopi(numTriangles) {
    loopj(3) {
      readString(in, line);
      GLfloat x, y, z, u, v;
      int n = sscanf(line, "%f %f %f %f %f", &x, &y, &z, &u, &v);
      printf("sscanf => %d\n", n);
      Vertex &vertex = sector1.triangle[i].vertex[j];
      vertex.x = x;
      vertex.y = y;
      vertex.z = z;
      vertex.u = u;
      vertex.v = v;
    }
  }
  
  fclose(in);
}

static void cleanExit(int returnCode) {
  SDL_Quit();
  exit(returnCode);
}

static inline bool isPowerOf2(int i) {
  return (i & (i - 1)) == 0;
}

static const char* textureFormatToString(GLenum textureFormat) {
  switch (textureFormat) {
    case GL_RGBA:
      return "GL_RGBA";
    case GL_BGRA:
      return "GL_BGRA";
      break;
    case GL_RGB:
      return "GL_RGB";
    case GL_BGR:
      return "GL_BGR";
      break;
    default:
      return "unknown texture format";
  }
}

static SDL_Surface *flipSurface(SDL_Surface *bitmap) {
  if (!bitmap) return NULL;
  SDL_Surface *result = SDL_CreateRGBSurface(0, bitmap->w, bitmap->h,
                                           bitmap->format->BitsPerPixel,
                                           bitmap->format->Rmask,
                                           bitmap->format->Gmask,
                                           bitmap->format->Bmask,
                                           bitmap->format->Amask);
  if (!result) return NULL;
  SDL_Rect src,dest;
  src.w = bitmap->w;
  src.h = 1;
  src.x = 0;
  dest.x = 0;
  int origh = bitmap->h;
  for (int i = 0; i < origh; ++i) {
    src.y = i;
    dest.y = (origh - 1) - i;
    SDL_BlitSurface(bitmap, &src, result, &dest);
  }
  return result;
}

static SDL_Surface *loadBitmap(const char filename[]) {
  SDL_Surface *bitmap = SDL_LoadBMP(filename);
  if (!bitmap) return NULL;
  SDL_Surface *flipped = flipSurface(bitmap);
  SDL_FreeSurface(bitmap);
  return flipped;
}

typedef struct {
  GLubyte r, g, b;
} RGB;

static bool loadTextures() {
  SDL_Surface *bitmap = loadBitmap("data/mud.bmp");
  if (!bitmap) return false;

  if (!isPowerOf2(bitmap->w)) {
    fprintf(stderr, "image width is not power of 2");
    return false;
  }
  if (!isPowerOf2(bitmap->h)) {
    fprintf(stderr, "image height is not power of 2");
    return false;
  }

  int numColours = bitmap->format->BytesPerPixel;
  GLenum texture_format;
  if (numColours == 4) {
    // Contains alpha channel.
    if (bitmap->format->Rmask == 0x000000ff) {
      texture_format = GL_RGBA;
    } else {
      texture_format = GL_BGRA;
    }
  } else if (numColours == 3) {
    // No alpha channel.
    if (bitmap->format->Rmask == 0x000000ff) {
      texture_format = GL_RGB;
    } else {
      texture_format = GL_BGR;
    }
  } else {
    fprintf(stderr, "Image is not true colour");
    return false;
  }
  printf("texture format is '%s'\n", textureFormatToString(texture_format));

  // Create the texture.
  glGenTextures(3, texture);
  
  // Create nearest filtered texture as texture[0].
  {
    glBindTexture(GL_TEXTURE_2D, texture[0]);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_NEAREST);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_NEAREST);
    glTexImage2D(GL_TEXTURE_2D, 0,
                 numColours, bitmap->w, bitmap->h,
                 0, texture_format,
                 GL_UNSIGNED_BYTE, bitmap->pixels);
  }

  // Create linear filtered texture as texture[1].
  {
    glBindTexture(GL_TEXTURE_2D, texture[1]);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
    glTexImage2D(GL_TEXTURE_2D, 0,
                 numColours, bitmap->w, bitmap->h,
                 0, texture_format,
                 GL_UNSIGNED_BYTE, bitmap->pixels);
  }

  // Create linear mipmapped texture as texture[2].
  {
    glBindTexture(GL_TEXTURE_2D, texture[2]);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR_MIPMAP_NEAREST);
    gluBuild2DMipmaps(GL_TEXTURE_2D, 
                      3, bitmap->w, bitmap->h, 
                      GL_BGR, GL_UNSIGNED_BYTE, 
                      bitmap->pixels);
  }
  
  SDL_FreeSurface(bitmap);

  for (int i = 0; i < 3; ++i) {
    printf("texture[%i] \"name\" is %i\n", i, texture[i]);    
  }

  return true;
}

static bool resizeWindow(int width, int height) {
  // Protect against a divide by zero.
  if (height == 0) height = 1;

  GLfloat ratio = (GLfloat)width / (GLfloat)height;

  // Setup our viewport.
  glViewport(0, 0, width, height);

  // Change to the projection matrix and set our viewing volume.
  glMatrixMode(GL_PROJECTION);
  glLoadIdentity();

  gluPerspective(45.0f, ratio, 0.1f, 100.0f);

  // Make sure we're chaning the model view and not the projection.
  glMatrixMode(GL_MODELVIEW);

  // Reset the view.
  glLoadIdentity();

  return true;
}

static void syncLighting() {
  if (lighting) {
    glEnable(GL_LIGHTING);
  } else {
    glDisable(GL_LIGHTING);
  }
  printf("lighting is %s\n", lighting? "on" : "off");
}

static void syncBlending() {
  if (blending) {
    glEnable(GL_BLEND);
  } else {
    glDisable(GL_BLEND);
  }
  printf("blending is %s\n", blending? "on" : "off");
}

static bool initGL() {
  if (!loadTextures()) return false;

  glEnable(GL_TEXTURE_2D);
  glShadeModel(GL_SMOOTH);

  glClearColor(0.0f, 0.0f, 0.0f, 0.0f);

  glClearDepth(1.0f);
  glDepthFunc(GL_LEQUAL);
  glEnable(GL_DEPTH_TEST);

  glColor4f(1.0f, 1.0f, 1.0f, 0.5f);
  glBlendFunc(GL_SRC_ALPHA, GL_ONE);
  syncBlending();

  glLightfv(GL_LIGHT1, GL_AMBIENT, lightAmbient);
  glLightfv(GL_LIGHT1, GL_DIFFUSE, lightDiffuse);
  glLightfv(GL_LIGHT1, GL_POSITION, lightPosition);
  glEnable(GL_LIGHT1);
  syncLighting();

  glHint(GL_PERSPECTIVE_CORRECTION_HINT, GL_NICEST);

  loadWorld();

  return true;
}

static void drawScene() {
  glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);

  glLoadIdentity();
  
  glRotatef(lookupdown, 1.0f, 0.0f, 0.0f);
  glRotatef(360.0f - yRot, 0.0f, 1.0f, 0.0f);

  GLfloat xTrans = -xPos;
  GLfloat zTrans = -zPos;
  GLfloat yTrans = -walkBias - 0.25f;

  glTranslatef(xTrans, yTrans, zTrans);

  glBindTexture(GL_TEXTURE_2D, texture[textureType]);
  
  loopi(sector1.numTriangles) {
    glBegin(GL_TRIANGLES);
    {
      glNormal3f(0.0f, 0.0f, 1.0f);

      loopj(3) {
        glTexCoord2f(sector1.triangle[i].vertex[j].u, sector1.triangle[i].vertex[j].v);
        glVertex3f(sector1.triangle[i].vertex[j].x,
                   sector1.triangle[i].vertex[j].y,
                   sector1.triangle[i].vertex[j].z);
      }
    }
    glEnd();
  }

  SDL_GL_SwapBuffers();

  // FPS.
  static GLint t0         = 0;
  static GLint frameCount = 0;
  ++frameCount;
  {
    GLint t = SDL_GetTicks();
    if (t - t0 >= 5000) {
      GLfloat seconds = (t - t0) / 1000.0;
      GLfloat fps = frameCount / seconds;
      printf("%d frames in %g seconds = %g FPS\n", frameCount, seconds, fps);
      t0 = t;
      frameCount = 0;
    }
  }
}

static const char* textureTypeToString(int textureType) {
  switch (textureType) {
    case 0:
      return "NEAREST";
    case 1:
      return "LINEAR";
    case 2:
      return "LINEAR_MIPMAP_NEAREST";
      break;
    default:
      break;
  }
  return "oops";
}

static void handleKeyPress(SDL_keysym *keysym) {
  switch (keysym->sym) {

    case SDLK_t:
      textureType = ++textureType % 3;
      printf("texture type = %s\n", textureTypeToString(textureType));
      break;

    case SDLK_b:
      blending = !blending;
      syncBlending();
      break;
      
    case SDLK_l:
      lighting = !lighting;
      syncLighting();
      break;

    case SDLK_RIGHT:
    case SDLK_d:
      yRot -= 1.5f;
      break;
    case SDLK_LEFT:
    case SDLK_a:
      yRot += 1.5f;
      break;

    case SDLK_UP:
    case SDLK_w:
      // Move player forward.
      // Move along x in the player direction.
      xPos -= sin(yRot * piover180) * 0.05f;
      // Move along z in the player direction.
      zPos -= cos(yRot * piover180) * 0.05f;
      if (walkBiasAngle >= 359.0f) {
        walkBiasAngle = 0.0f;
      } else {
        walkBiasAngle += 10;
      }
      walkBias = sin(walkBiasAngle * piover180) / 20.0f;
      break;
    case SDLK_DOWN:
    case SDLK_s:
      // Move player backwards.
      // Move along x in the player direction.
      xPos += sin(yRot * piover180) * 0.05f;
      // Move along z in the player direction.
      zPos += cos(yRot * piover180) * 0.05f;
      if (walkBiasAngle <= 1.0f) {
        walkBiasAngle = 359.0f;
      } else {
        walkBiasAngle -= 10;
      }      
      walkBias = sin(walkBiasAngle * piover180) / 20.0f;
      break;

    case SDLK_PAGEDOWN:
      lookupdown -= 1.0f;
      break;
    case SDLK_PAGEUP:
      lookupdown += 1.0f;
      break;
      
    case SDLK_ESCAPE:
    case SDLK_q:
      printf("q/Esc pressed\n");
      cleanExit(0);
      break;

    case SDLK_F1:
    case SDLK_f:
      printf("F1/f pressed - toggle fullscreen\n");
      videoFlags ^= SDL_FULLSCREEN; // Toggle fullscreen bit.
      surface = SDL_SetVideoMode(SCREEN_WIDTH,
                                 SCREEN_HEIGHT,
                                 SCREEN_BPP, videoFlags);
      initGL();  
      resizeWindow(SCREEN_WIDTH, SCREEN_HEIGHT);
      break;

	default:
      break;
  }

  return;
}

int main(int argc, char *argv[]) {
  if (SDL_Init(SDL_INIT_VIDEO) < 0) {
    fprintf(stderr, "Video initialization failed: %s\n", SDL_GetError());
    cleanExit(1);
  }

  const SDL_VideoInfo *videoInfo = SDL_GetVideoInfo();

  if (!videoInfo) {
    fprintf(stderr, "Video query failed: %s\n", SDL_GetError());
    cleanExit(1);
  }

  videoFlags     |= SDL_DOUBLEBUF | SDL_HWSURFACE;
  videoFlags     |= SDL_HWPALETTE;
  videoFlags     |= SDL_RESIZABLE;

  SDL_GL_SetAttribute(SDL_GL_DOUBLEBUFFER, 1);

  surface = SDL_SetVideoMode(SCREEN_WIDTH, SCREEN_HEIGHT, SCREEN_BPP, videoFlags);
  if (!surface) {
    fprintf(stderr, "Video mode set failed: %s\n", SDL_GetError());
    cleanExit(1);
  }

  printf("screen is hardware surface = %d\n", (surface->flags & SDL_HWSURFACE == 0));

  initGL();  
  resizeWindow(SCREEN_WIDTH, SCREEN_HEIGHT);
  SDL_EnableKeyRepeat(100, 50);

  // Event loop.
  for (;;) {
    SDL_Event event;
    while (SDL_PollEvent(&event)) {
      switch (event.type) {
        case SDL_VIDEORESIZE:
          printf("SDL_VIDEORESIZE w=%d h=%d\n", event.resize.w, event.resize.h, event.resize);
          surface = SDL_SetVideoMode(event.resize.w,
                                     event.resize.h,
                                     SCREEN_BPP, videoFlags);
          if (!surface) {
            fprintf(stderr, "Could not get a surface after resize: %s\n", SDL_GetError());
            cleanExit(1);
          }
          initGL();  
          resizeWindow(SCREEN_WIDTH, SCREEN_HEIGHT);
          break;
        case SDL_KEYDOWN:
          handleKeyPress(&event.key.keysym);
          break;
        case SDL_QUIT:
          printf("SDL_QUIT\n");
          goto finished;
        default:
          break;
      }
    }
    
    drawScene();
  }
finished:

  cleanExit(0);

  // Never reached.
  return 0;
}
