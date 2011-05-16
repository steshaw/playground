#include <stdlib.h>
#include <OpenGL/gl.h>
#include <OpenGL/glu.h>
#include <GLUT/glut.h>

#define WINDOW_WIDTH  600
#define WINDOW_HEIGHT 450

static float rotTriangle = 0.0f;
static float rotQuad = 0.0f;

void initGL() {
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

  glTranslatef(-1.5f, 0.0f, -6.0f);
 
  glPushMatrix();
  {
    glRotatef(rotTriangle, 0.0f, 1.0f, 0.0f);

    // Pyramid.
    glBegin(GL_TRIANGLES); 
    {
      // Front.
      glColor3f(1.0f,0.0f,0.0f);
      glVertex3f(0.0f, 1.0f, 0.0f);
      glColor3f(0.0f,1.0f,0.0f);
      glVertex3f(-1.0f, -1.0f, 1.0f);
      glColor3f(0.0f,0.0f,1.0f);
      glVertex3f(1.0f, -1.0f, 1.0f);
      
      // Right.
      glColor3f(1.0f,0.0f,0.0f);
      glVertex3f( 0.0f, 1.0f, 0.0f);
      glColor3f(0.0f,0.0f,1.0f);
      glVertex3f( 1.0f,-1.0f, 1.0f);
      glColor3f(0.0f,1.0f,0.0f);
      glVertex3f( 1.0f,-1.0f, -1.0f);
      glColor3f(1.0f,0.0f,0.0f);
      
      // Back.
      glVertex3f( 0.0f, 1.0f, 0.0f);
      glColor3f(0.0f,1.0f,0.0f);
      glVertex3f( 1.0f,-1.0f, -1.0f);
      glColor3f(0.0f,0.0f,1.0f);
      glVertex3f(-1.0f,-1.0f, -1.0f);
      
      // Left.
      glColor3f(1.0f,0.0f,0.0f);
      glVertex3f( 0.0f, 1.0f, 0.0f);
      glColor3f(0.0f,0.0f,1.0f);
      glVertex3f(-1.0f,-1.0f,-1.0f);
      glColor3f(0.0f,1.0f,0.0f);
      glVertex3f(-1.0f,-1.0f, 1.0f);
    }
    glEnd();
  }
  glPopMatrix();
  
/*
  glLoadIdentity();
  glTranslatef(1.5f, 0.0f, -6.0f);
*/
  glTranslatef(3.0f, 0.0f, 0.0f);
  
  glRotatef(rotQuad, 1.0f, 0.0f, 0.0f);
  glColor3f(0.5, 0.5f, 1.0f);
  glBegin(GL_QUADS);
  {
    // Top.
    glColor3f(0.0f,1.0f,0.0f);
    glVertex3f( 1.0f, 1.0f,-1.0f);
    glVertex3f(-1.0f, 1.0f,-1.0f);
    glVertex3f(-1.0f, 1.0f, 1.0f);
    glVertex3f( 1.0f, 1.0f, 1.0f);
    
    // Bottom.
    glColor3f(1.0f,0.5f,0.0f);
    glVertex3f( 1.0f,-1.0f, 1.0f);			// Top Right Of The Quad (Bottom)
    glVertex3f(-1.0f,-1.0f, 1.0f);			// Top Left Of The Quad (Bottom)
    glVertex3f(-1.0f,-1.0f,-1.0f);			// Bottom Left Of The Quad (Bottom)
    glVertex3f( 1.0f,-1.0f,-1.0f);			// Bottom Right Of The Quad (Bottom)

    // Front.
    glColor3f(1.0f,0.0f,0.0f);
    glVertex3f( 1.0f, 1.0f, 1.0f);			// Top Right Of The Quad (Front)
    glVertex3f(-1.0f, 1.0f, 1.0f);			// Top Left Of The Quad (Front)
    glVertex3f(-1.0f,-1.0f, 1.0f);			// Bottom Left Of The Quad (Front)
    glVertex3f( 1.0f,-1.0f, 1.0f);			// Bottom Right Of The Quad (Front)
    
    // Back.
    glColor3f(1.0f,1.0f,0.0f);
    glVertex3f( 1.0f,-1.0f,-1.0f);			// Bottom Left Of The Quad (Back)
    glVertex3f(-1.0f,-1.0f,-1.0f);			// Bottom Right Of The Quad (Back)
    glVertex3f(-1.0f, 1.0f,-1.0f);			// Top Right Of The Quad (Back)
    glVertex3f( 1.0f, 1.0f,-1.0f);			// Top Left Of The Quad (Back)
    
    // Left.
    glColor3f(0.0f,0.0f,1.0f);
    glVertex3f(-1.0f, 1.0f, 1.0f);			// Top Right Of The Quad (Left)
    glVertex3f(-1.0f, 1.0f,-1.0f);			// Top Left Of The Quad (Left)
    glVertex3f(-1.0f,-1.0f,-1.0f);			// Bottom Left Of The Quad (Left)
    glVertex3f(-1.0f,-1.0f, 1.0f);			// Bottom Right Of The Quad (Left)
    
    // Right.
    glColor3f(1.0f,0.0f,1.0f);
    glVertex3f( 1.0f, 1.0f,-1.0f);			// Top Right Of The Quad (Right)
    glVertex3f( 1.0f, 1.0f, 1.0f);			// Top Left Of The Quad (Right)
    glVertex3f( 1.0f,-1.0f, 1.0f);			// Bottom Left Of The Quad (Right)
    glVertex3f( 1.0f,-1.0f,-1.0f);			// Bottom Right Of The Quad (Right)
  }
  glEnd();
  
  rotTriangle += 0.2f;
  rotQuad -= 0.15f;

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
