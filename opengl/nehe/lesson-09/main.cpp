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
#include <OpenGL/gl.h>
#include <OpenGL/glu.h>
#include <SDL/SDL.h>

#define loop(v, m) for(int v = 0; v<(m); v++)
#define loopi(m) loop(i,m)
#define loopj(m) loop(j,m)
#define loopk(m) loop(k,m)
#define loopl(m) loop(l,m)

#define SCREEN_WIDTH  640
#define SCREEN_HEIGHT 480
#define SCREEN_BPP     16

static SDL_Surface *surface;

static GLuint textureType = 1; // Linear-filtered texture.
static GLuint texture[3];

static bool twinkling = false;
static bool randomTwinkle = false;

static bool animate = true;

const int numStars = 50;

static GLfloat zoom = -15.0f;
static GLfloat tilt = 90.0f;
static GLfloat spin = 0.0f;

struct Star {
  int r, g, b;
  GLfloat distance;
  GLfloat angle;
};

static Star star[numStars];

static int videoFlags  = SDL_OPENGL;

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
  SDL_Surface *bitmap = loadBitmap("data/star.bmp");
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

  // Create the textures.
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

static inline GLuint randColor() {
  return rand() % 256;
}

static void initStars() {
  loopi (numStars) {
    star[i].angle = 0.0f;
    star[i].distance = float(i)/numStars * 5.0f;
    star[i].r = randColor();
    star[i].g = randColor();
    star[i].b = randColor();
  }
}

static bool initGL() {
  if (!loadTextures()) return false;

  glEnable(GL_TEXTURE_2D);
  glShadeModel(GL_SMOOTH);

  glClearColor(0.0f, 0.0f, 0.0f, 0.5f);
  glClearDepth(1.0f);
  glHint(GL_PERSPECTIVE_CORRECTION_HINT, GL_NICEST);

  glBlendFunc(GL_SRC_ALPHA, GL_ONE);
  glEnable(GL_BLEND);

  initStars();

  return true;
}

static void drawStarQuads() {
  glBegin(GL_QUADS);
  {
    glTexCoord2f(0.0f, 0.0f); glVertex3f(-1.0f, -1.0f, 0.0f);
    glTexCoord2f(1.0f, 0.0f); glVertex3f( 1.0f, -1.0f, 0.0f);
    glTexCoord2f(1.0f, 1.0f); glVertex3f( 1.0f,  1.0f, 0.0f);
    glTexCoord2f(0.0f, 1.0f); glVertex3f(-1.0f,  1.0f, 0.0f);
  }
  glEnd();
}

static void animationStep(int i, Star &star) {
  spin += 0.01f;
  star.angle += float(i) / numStars;
  star.distance -= 0.01f;
}

static void animationStepAll() {
  loopi (numStars) {
    animationStep(i, star[i]);
  }
}

static void drawScene() {
  glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);

  glBindTexture(GL_TEXTURE_2D, texture[textureType]);
  
#if 0
  printf("tilt = %g\n", tilt);
  printf("zoom = %g\n", zoom);
#endif

  loopi(numStars) {
    glLoadIdentity();
    glTranslatef(0.0f, 0.0f, zoom);
    glRotatef(tilt, 1.0f, 0.0f, 0.0f);

    glRotatef(star[i].angle, 0.0f, 1.0f, 0.0f);
    glTranslatef(star[i].distance, 0.0f, 0.0f);

    // Cancel rotations.
    glRotatef(-star[i].angle, 0.0f, 1.0f, 0.0f);
    glRotatef(-tilt, 1.0f, 0.0f, 0.0f);

    // Handle twinkling.
    if (twinkling) {
      if (randomTwinkle) {
        glColor4ub(randColor(), randColor(), randColor(), 255);
      } else {
        // Select another star the same distance from the end of the array as this one is from the beginning.
        Star other = star[numStars - i - 1];
        glColor4ub(other.r, other.g, other.b, 255);
      }
      drawStarQuads();
    }

    // Draw star.
    glRotatef(spin, 0.0f, 0.0f, 1.0f);
    glColor4ub(star[i].r, star[i].g, star[i].b, 255);
    drawStarQuads();

    // Adjust stars.
    if (animate) {
      animationStep(i, star[i]);
    }
    
    // Reset star if reached middle.
    if (star[i].distance < 0.0f) {
      star[i].distance += 5.0f;
      star[i].r = randColor();
      star[i].g = randColor();
      star[i].b = randColor();
    }
  }

  SDL_GL_SwapBuffers();

  // Frames per second.
  static GLint t0     = 0;
  static GLint frames = 0;
  ++frames;
  {
    GLint t = SDL_GetTicks();
    if (t - t0 >= 5000) {
      double seconds = (t - t0) / 1000.0;
      double fps = frames / seconds;
      printf("%d frames in %g seconds = %g fps\n", frames, seconds, fps);
    
      // Reset.
      t0 = t;
      frames = 0;
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

    case SDLK_a:
      animate = !animate;
      printf("animate = %s\n", animate? "on" : "off");
      break;

    case SDLK_i:
      initStars();
      printf("stars reinitialised\n");
      break;

    case SDLK_s:
      animationStepAll();
      printf("animationStepAll()\n");
      break;

    case SDLK_k:
      twinkling = !twinkling;
      printf("twinkling = %s\n", twinkling? "on" : "off");
      break;

    case SDLK_r:
      randomTwinkle = !randomTwinkle;
      printf("random twinkling = %s\n", randomTwinkle? "on" : "off");
      break;

    case SDLK_t:
      textureType = ++textureType % 3;
      printf("texture type = %s\n", textureTypeToString(textureType));
      break;

    case SDLK_UP:
      tilt -= 0.5f;
      break;
    case SDLK_DOWN:
      tilt += 0.5f;
      break;

    case SDLK_PAGEDOWN:
      zoom -= 0.2f;
      break;
    case SDLK_PAGEUP:
      zoom += 0.2f;
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
