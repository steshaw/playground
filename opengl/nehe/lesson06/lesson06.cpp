/*
 * Adapted from original code. See below.
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

#define SCREEN_WIDTH  640
#define SCREEN_HEIGHT 480
#define SCREEN_BPP     16

static SDL_Surface *surface;

static GLfloat xrot = 0.0f;
static GLfloat yrot = 0.0f;
static GLfloat zrot = 0.0f;

int videoFlags  = SDL_OPENGL;

static GLuint texture[1];

void cleanExit(int returnCode) {
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

SDL_Surface *flipSurface(SDL_Surface *bitmap) {
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

SDL_Surface *loadBitmap(const char filename[]) {
  SDL_Surface *bitmap = SDL_LoadBMP("data/nehe.bmp");
  if (!bitmap) return NULL;
  SDL_Surface *flipped = flipSurface(bitmap);
  SDL_FreeSurface(bitmap);
  return flipped;
}

typedef struct {
  GLubyte r, g, b;
} RGB;

void flipPixels(RGB bmp[], SDL_Surface *bitmap) {
  RGB *pixels = (RGB*)bitmap->pixels;

  for (int x = 0; x < bitmap->h; ++x) {
    for (int y = 0; y < bitmap->w; ++y) {
      bmp[(bitmap->h - 1 - x) * bitmap->w + bitmap->w - 1 - y] = pixels[x * bitmap->w + y];
    }
  }
}

bool loadTextures() {
  SDL_Surface *bitmap = loadBitmap("data/nehe.bmp");
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
  glGenTextures(1, &texture[1]);

  // Typical texture generation using data from the bitmap.
  glBindTexture(GL_TEXTURE_2D, texture[0]);

  // Linear Filtering.
  glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
  glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
  
  bool withMipMap = false;
  if (withMipMap) {
    gluBuild2DMipmaps(GL_TEXTURE_2D, 
                      3, bitmap->w, bitmap->h, 
                      GL_BGR, GL_UNSIGNED_BYTE, 
                      bitmap->pixels);
  } else {
    RGB bmp[bitmap->w * bitmap->h];
    flipPixels(bmp, bitmap);
    bool flip = false;
    glTexImage2D(GL_TEXTURE_2D, 0,
                 numColours, bitmap->w, bitmap->h,
                 0, texture_format,
                 GL_UNSIGNED_BYTE, flip? bmp : bitmap->pixels);
  }

  SDL_FreeSurface(bitmap);

  printf("texture \"name\" is %d\n", texture[0]);
  return true;
}

bool resizeWindow(int width, int height) {
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

bool initGL() {
  if (!loadTextures()) return false;

  glEnable(GL_TEXTURE_2D);
  glShadeModel(GL_SMOOTH);

  // Set the background black.
  glClearColor(0.0f, 0.0f, 0.0f, 0.5f);

  glClearDepth(1.0f);

  glEnable(GL_DEPTH_TEST);  
  glDepthFunc(GL_LEQUAL);

  glHint(GL_PERSPECTIVE_CORRECTION_HINT, GL_NICEST);

  return true;
}

void drawScene() {
  // These are to calculate our fps.
  static GLint t0         = 0;
  static GLint frameCount = 0;
  
  glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
  
  // Move into the screen 5 units.
  glLoadIdentity();
  glTranslatef(0.0f, 0.0f, -5.0f);
  
  glRotatef(xrot, 1.0f, 0.0f, 0.0f);
  glRotatef(yrot, 0.0f, 1.0f, 0.0f);
  glRotatef(zrot, 0.0f, 0.0f, 1.0f);

  glBindTexture(GL_TEXTURE_2D, texture[0]);

  glBegin(GL_QUADS);
  {
    // Front Face
    glTexCoord2f(0.0f, 0.0f); glVertex3f(-1.0f, -1.0f,  1.0f);	// Bottom Left Of The Texture and Quad
    glTexCoord2f(1.0f, 0.0f); glVertex3f( 1.0f, -1.0f,  1.0f);	// Bottom Right Of The Texture and Quad
    glTexCoord2f(1.0f, 1.0f); glVertex3f( 1.0f,  1.0f,  1.0f);	// Top Right Of The Texture and Quad
    glTexCoord2f(0.0f, 1.0f); glVertex3f(-1.0f,  1.0f,  1.0f);	// Top Left Of The Texture and Quad
    // Back Face
    glTexCoord2f(1.0f, 0.0f); glVertex3f(-1.0f, -1.0f, -1.0f);	// Bottom Right Of The Texture and Quad
    glTexCoord2f(1.0f, 1.0f); glVertex3f(-1.0f,  1.0f, -1.0f);	// Top Right Of The Texture and Quad
    glTexCoord2f(0.0f, 1.0f); glVertex3f( 1.0f,  1.0f, -1.0f);	// Top Left Of The Texture and Quad
    glTexCoord2f(0.0f, 0.0f); glVertex3f( 1.0f, -1.0f, -1.0f);	// Bottom Left Of The Texture and Quad
    // Top Face
    glTexCoord2f(0.0f, 1.0f); glVertex3f(-1.0f,  1.0f, -1.0f);	// Top Left Of The Texture and Quad
    glTexCoord2f(0.0f, 0.0f); glVertex3f(-1.0f,  1.0f,  1.0f);	// Bottom Left Of The Texture and Quad
    glTexCoord2f(1.0f, 0.0f); glVertex3f( 1.0f,  1.0f,  1.0f);	// Bottom Right Of The Texture and Quad
    glTexCoord2f(1.0f, 1.0f); glVertex3f( 1.0f,  1.0f, -1.0f);	// Top Right Of The Texture and Quad
    // Bottom Face
    glTexCoord2f(1.0f, 1.0f); glVertex3f(-1.0f, -1.0f, -1.0f);	// Top Right Of The Texture and Quad
    glTexCoord2f(0.0f, 1.0f); glVertex3f( 1.0f, -1.0f, -1.0f);	// Top Left Of The Texture and Quad
    glTexCoord2f(0.0f, 0.0f); glVertex3f( 1.0f, -1.0f,  1.0f);	// Bottom Left Of The Texture and Quad
    glTexCoord2f(1.0f, 0.0f); glVertex3f(-1.0f, -1.0f,  1.0f);	// Bottom Right Of The Texture and Quad
    // Right face
    glTexCoord2f(1.0f, 0.0f); glVertex3f( 1.0f, -1.0f, -1.0f);	// Bottom Right Of The Texture and Quad
    glTexCoord2f(1.0f, 1.0f); glVertex3f( 1.0f,  1.0f, -1.0f);	// Top Right Of The Texture and Quad
    glTexCoord2f(0.0f, 1.0f); glVertex3f( 1.0f,  1.0f,  1.0f);	// Top Left Of The Texture and Quad
    glTexCoord2f(0.0f, 0.0f); glVertex3f( 1.0f, -1.0f,  1.0f);	// Bottom Left Of The Texture and Quad
    // Left Face
    glTexCoord2f(0.0f, 0.0f); glVertex3f(-1.0f, -1.0f, -1.0f);	// Bottom Left Of The Texture and Quad
    glTexCoord2f(1.0f, 0.0f); glVertex3f(-1.0f, -1.0f,  1.0f);	// Bottom Right Of The Texture and Quad
    glTexCoord2f(1.0f, 1.0f); glVertex3f(-1.0f,  1.0f,  1.0f);	// Top Right Of The Texture and Quad
    glTexCoord2f(0.0f, 1.0f); glVertex3f(-1.0f,  1.0f, -1.0f);	// Top Left Of The Texture and Quad
  }
  glEnd();
  
  SDL_GL_SwapBuffers();
  
  // Gather our frames per second.
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

  if (true) {    
    xrot += 0.3f / 2 / 2 / 2;
    yrot += 0.2f / 2 / 2 / 2;
    zrot += 0.4f / 2 / 2 / 2;
  }
}

void handleKeyPress(SDL_keysym *keysym) {
  switch (keysym->sym) {
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
