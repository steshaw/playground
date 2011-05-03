#include <stdlib.h>
#include <OpenGL/gl.h>
#include <OpenGL/glu.h>
#include <OpenGL/glaux.h>
#include <GLUT/glut.h>

#define WINDOW_WIDTH  600
#define WINDOW_HEIGHT 450

static struct {
  float x, y, z;
} g_rot;

static GLuint g_texture[1]; // Storage for one texture (reference/id);

AUX_RGBImageRec* loadBitmap(char filename[]) {
  return null;
}

void initGL() {
  glEnable(GL_TEXTURE_2D);
  glShadeModel(GL_SMOOTH);
  glClearColor(0.0f, 0.0f, 0.0f, 0.0f);
  glClearDepth(1.0f);
  glEnable(GL_DEPTH_TEST);
  glDepthFunc(GL_LEQUAL);
  glHint(GL_PERSPECTIVE_CORRECTION_HINT, GL_NICEST);
}

void displayGL() {
  glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
  glLoadIdentity();
  glTranslatef(-1.5f, 0.0f, -5.0f);

  glRotatef(g_rot.x, 1.0f, 0.0f, 0.0f);
  glRotatef(g_rot.y, 0.0f, 1.0f, 0.0f);
  glRotatef(g_rot.z, 0.0f, 0.0f, 1.0f);
  
  glutSwapBuffers();  
}

void reshapeGL(int width, int height) {
  if (height == 0) {
    height = 1;
  }
  glViewport(0, 0, width, height);
  glMatrixMode(GL_PROJECTION);
  glLoadIdentity();
  gluPerspective(45.0f, ((GLfloat)width) / ((GLfloat)height), 0.1f, 100.0f);
  glMatrixMode(GL_MODELVIEW);
  glLoadIdentity();
}

#define ESC 27

void keyboard(unsigned char key, int x, int y) {
  if (key == ESC) exit(0);
}

void arrowKeys(int aKeys, int x, int y) {
  switch (aKeys) {
    case GLUT_KEY_UP:
      glutFullScreen();
      break;      
    case GLUT_KEY_DOWN:
      glutInitWindowPosition(300, 300);
      glutReshapeWindow(WINDOW_WIDTH, WINDOW_HEIGHT);
      break;
  }
}

int main(int argc, char *argv[]) {
  glutInit(&argc, argv);
  glutInitDisplayMode(GLUT_DOUBLE | GLUT_RGB | GLUT_DEPTH);
  glutInitWindowSize(WINDOW_WIDTH, WINDOW_HEIGHT);
  glutInitWindowPosition(300, 300);
  glutCreateWindow(argv[0]);

  initGL();

  glutDisplayFunc(displayGL);
  glutReshapeFunc(reshapeGL);
  glutKeyboardFunc(keyboard);
  glutSpecialFunc(arrowKeys);
  glutIdleFunc(displayGL);

  glutMainLoop();

  return 0;
}