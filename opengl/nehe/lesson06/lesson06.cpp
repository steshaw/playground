/*
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

int loadTextures() {
  SDL_Surface *textureImage[1];
  textureImage[0] = SDL_LoadBMP("data/nehe.bmp");
  if (!textureImage[0]) return false;
  
  // Create the texture.
  glGenTextures(1, &texture[0]);
  
  // Typical texture generation using data from the bitmap.
  glBindTexture(GL_TEXTURE_2D, texture[0]);
  
  // Generate the texture.
  glTexImage2D(GL_TEXTURE_2D, 0, 3, 
               textureImage[0]->w, textureImage[0]->h, 
               0, GL_BGR,
               GL_UNSIGNED_BYTE, textureImage[0]->pixels);
  
  // Linear Filtering.
  glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
  glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);

  SDL_FreeSurface(textureImage[0]);
  return true;
}

int resizeWindow(int width, int height) {
  // Protect against a divide by zero.
  if (height == 0) height = 1;
  
  GLfloat ratio = (GLfloat)width / (GLfloat)height;
  
  // Setup our viewport.
  glViewport(0, 0, width, height);
  
  // Change to the projection matrix and set our viewing volume.
  glMatrixMode(GL_PROJECTION);
  glLoadIdentity( );
  
  /* Set our perspective */
  gluPerspective(45.0f, ratio, 0.1f, 100.0f);
  
  /* Make sure we're chaning the model view and not the projection */
  glMatrixMode(GL_MODELVIEW);
  
  // Reset The View
  glLoadIdentity();
  
  return true;
}

void handleKeyPress(SDL_keysym *keysym) {
  switch (keysym->sym) {
	case SDLK_ESCAPE:
    case SDLK_q:
      printf("q/Esc pressed\n");
      cleanExit(0);
      break;
    case SDLK_f:
      printf("f pressed\n");
      videoFlags |= SDL_FULLSCREEN;
      surface = SDL_SetVideoMode(SCREEN_WIDTH,
                                 SCREEN_HEIGHT,
                                 SCREEN_BPP, videoFlags);
      resizeWindow(SCREEN_WIDTH, SCREEN_HEIGHT);
      break;
	case SDLK_F1:
      printf("F1 pressed\n");
      SDL_WM_ToggleFullScreen(surface); // XXX: Seems to be broken...
      break;
	default:
      break;
  }
  
  return;
}

/* general OpenGL initialization function */
int initGL() {
  if (!loadTextures()) return false;
  
  glEnable(GL_TEXTURE_2D);
  glShadeModel(GL_SMOOTH);
  
  /* Set the background black */
  glClearColor( 0.0f, 0.0f, 0.0f, 0.5f );
  
  glClearDepth(1.0f);
  
  glEnable(GL_DEPTH_TEST);  
  glDepthFunc(GL_LEQUAL);
  
  glHint(GL_PERSPECTIVE_CORRECTION_HINT, GL_NICEST);
  
  return true;
}

/* Here goes our drawing code */
void drawScene() {
  /* These are to calculate our fps */
  static GLint t0         = 0;
  static GLint frameCount = 0;
  
  glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
  
  /* Move Into The Screen 5 Units */
  glLoadIdentity();
  glTranslatef(0.0f, 0.0f, -5.0f);
  
  glRotatef(xrot, 1.0f, 0.0f, 0.0f);
  glRotatef(yrot, 0.0f, 1.0f, 0.0f);
  glRotatef(zrot, 0.0f, 0.0f, 1.0f);
  
  glBindTexture(GL_TEXTURE_2D, texture[0]);
  
  /* NOTE:
   *   The x coordinates of the glTexCoord2f function need to inverted
   * for SDL because of the way SDL_LoadBmp loads the data. So where
   * in the tutorial it has glTexCoord2f( 1.0f, 0.0f ); it should
   * now read glTexCoord2f( 0.0f, 0.0f );
   */
  glBegin(GL_QUADS);
  {    
    /* Front Face */
    /* Bottom Left Of The Texture and Quad */
    glTexCoord2f( 0.0f, 1.0f ); glVertex3f( -1.0f, -1.0f, 1.0f );
    /* Bottom Right Of The Texture and Quad */
    glTexCoord2f( 1.0f, 1.0f ); glVertex3f(  1.0f, -1.0f, 1.0f );
    /* Top Right Of The Texture and Quad */
    glTexCoord2f( 1.0f, 0.0f ); glVertex3f(  1.0f,  1.0f, 1.0f );
    /* Top Left Of The Texture and Quad */
    glTexCoord2f( 0.0f, 0.0f ); glVertex3f( -1.0f,  1.0f, 1.0f );
    
    /* Back Face */
    /* Bottom Right Of The Texture and Quad */
    glTexCoord2f( 0.0f, 0.0f ); glVertex3f( -1.0f, -1.0f, -1.0f );
    /* Top Right Of The Texture and Quad */
    glTexCoord2f( 0.0f, 1.0f ); glVertex3f( -1.0f,  1.0f, -1.0f );
    /* Top Left Of The Texture and Quad */
    glTexCoord2f( 1.0f, 1.0f ); glVertex3f(  1.0f,  1.0f, -1.0f );
    /* Bottom Left Of The Texture and Quad */
    glTexCoord2f( 1.0f, 0.0f ); glVertex3f(  1.0f, -1.0f, -1.0f );
    
    /* Top Face */
    /* Top Left Of The Texture and Quad */
    glTexCoord2f( 1.0f, 1.0f ); glVertex3f( -1.0f,  1.0f, -1.0f );
    /* Bottom Left Of The Texture and Quad */
    glTexCoord2f( 1.0f, 0.0f ); glVertex3f( -1.0f,  1.0f,  1.0f );
    /* Bottom Right Of The Texture and Quad */
    glTexCoord2f( 0.0f, 0.0f ); glVertex3f(  1.0f,  1.0f,  1.0f );
    /* Top Right Of The Texture and Quad */
    glTexCoord2f( 0.0f, 1.0f ); glVertex3f(  1.0f,  1.0f, -1.0f );
    
    /* Bottom Face */
    /* Top Right Of The Texture and Quad */
    glTexCoord2f( 0.0f, 1.0f ); glVertex3f( -1.0f, -1.0f, -1.0f );
    /* Top Left Of The Texture and Quad */
    glTexCoord2f( 1.0f, 1.0f ); glVertex3f(  1.0f, -1.0f, -1.0f );
    /* Bottom Left Of The Texture and Quad */
    glTexCoord2f( 1.0f, 0.0f ); glVertex3f(  1.0f, -1.0f,  1.0f );
    /* Bottom Right Of The Texture and Quad */
    glTexCoord2f( 0.0f, 0.0f ); glVertex3f( -1.0f, -1.0f,  1.0f );
    
    /* Right face */
    /* Bottom Right Of The Texture and Quad */
    glTexCoord2f( 0.0f, 0.0f ); glVertex3f( 1.0f, -1.0f, -1.0f );
    /* Top Right Of The Texture and Quad */
    glTexCoord2f( 0.0f, 1.0f ); glVertex3f( 1.0f,  1.0f, -1.0f );
    /* Top Left Of The Texture and Quad */
    glTexCoord2f( 1.0f, 1.0f ); glVertex3f( 1.0f,  1.0f,  1.0f );
    /* Bottom Left Of The Texture and Quad */
    glTexCoord2f( 1.0f, 0.0f ); glVertex3f( 1.0f, -1.0f,  1.0f );
    
    /* Left Face */
    /* Bottom Left Of The Texture and Quad */
    glTexCoord2f( 1.0f, 0.0f ); glVertex3f( -1.0f, -1.0f, -1.0f );
    /* Bottom Right Of The Texture and Quad */
    glTexCoord2f( 0.0f, 0.0f ); glVertex3f( -1.0f, -1.0f,  1.0f );
    /* Top Right Of The Texture and Quad */
    glTexCoord2f( 0.0f, 1.0f ); glVertex3f( -1.0f,  1.0f,  1.0f );
    /* Top Left Of The Texture and Quad */
    glTexCoord2f( 1.0f, 1.0f ); glVertex3f( -1.0f,  1.0f, -1.0f );
  }
  glEnd();
  
  SDL_GL_SwapBuffers();
  
  /* Gather our frames per second */
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
  
  xrot += 0.3f; /* X Axis Rotation */
  yrot += 0.2f; /* Y Axis Rotation */
  zrot += 0.4f; /* Z Axis Rotation */
}

int main(int argc, char *argv[]) {
  /* initialize SDL */
  if (SDL_Init(SDL_INIT_VIDEO) < 0) {
    fprintf( stderr, "Video initialization failed: %s\n",
            SDL_GetError( ) );
    cleanExit(1);
  }
  
  /* Fetch the video info */
  const SDL_VideoInfo *videoInfo = SDL_GetVideoInfo( );
  
  if (!videoInfo) {
    fprintf( stderr, "Video query failed: %s\n",
            SDL_GetError( ) );
    cleanExit(1);
  }
  
  /* the flags to pass to SDL_SetVideoMode */
  videoFlags     |= SDL_GL_DOUBLEBUFFER; /* Enable double buffering */
  videoFlags     |= SDL_HWPALETTE;       /* Store the palette in hardware */
  videoFlags     |= SDL_RESIZABLE;       /* Enable window resizing */
//  videoInfo    |= SDL_FULLSCREEN;
  
  /* This checks to see if surfaces can be stored in memory */
  if ( videoInfo->hw_available ) {
    printf("Hardware surface\n");
	videoFlags |= SDL_HWSURFACE;
  } else {
    printf("Software surface\n");
	videoFlags |= SDL_SWSURFACE;
  }
  
  /* This checks if hardware blits can be done */
  printf("Hardware blit = %d\n", videoInfo->blit_hw);
  if ( videoInfo->blit_hw ) {
	videoFlags |= SDL_HWACCEL;
  }
  
  /* Sets up OpenGL double buffering */
  SDL_GL_SetAttribute(SDL_GL_DOUBLEBUFFER, 1);
  
  /* get a SDL surface */
  surface = SDL_SetVideoMode(SCREEN_WIDTH, SCREEN_HEIGHT, SCREEN_BPP, videoFlags);
  
  printf("screen is hardware surface = %d\n", (surface->flags & SDL_HWSURFACE == 0));
  
  /* Verify there is a surface */
  if (!surface) {
    fprintf( stderr,  "Video mode set failed: %s\n", SDL_GetError( ) );
    cleanExit(1);
  }
  
  /* initialize OpenGL */
  initGL();
  
  /* resize the initial window */
  resizeWindow(SCREEN_WIDTH, SCREEN_HEIGHT);
  
  /* wait for events */
  for (;;) {
    /* handle the events in the queue */
    SDL_Event event;    
    while (SDL_PollEvent(&event)) {
      switch (event.type) {
        case SDL_VIDEORESIZE:
          printf("SDL_VIDEORESIZE w=%d h=%d\n", event.resize.w, event.resize.h, event.resize);
          surface = SDL_SetVideoMode(event.resize.w,
                                     event.resize.h,
                                     SCREEN_BPP, videoFlags);
          if (!surface) {
            fprintf( stderr, "Could not get a surface after resize: %s\n", SDL_GetError( ) );
            cleanExit(1);
          }
          resizeWindow(event.resize.w, event.resize.h);
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
