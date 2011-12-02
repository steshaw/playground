
typedef int B;

class A {
public:
  A(int sz) : v(new B[sz]), sz_(sz) {}
  ~A() { delete[] v; }
private:
  A(const A&);
  A& operator=(const A&);

  B *v;
  int sz_;
};
