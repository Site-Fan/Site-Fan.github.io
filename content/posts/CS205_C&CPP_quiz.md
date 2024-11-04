---
title: CS205 C/C++ Solutions to Quizzes
tags: C/C++
categories: CS
description: Solutions to quizzes for CS205 in 2022 Fall.
date: 2023-01-09
---

### Getting Started

#### Q1

The source code of program is as follows:

```cpp
int main(int argc, char *argv[])
{
    //...
}
```

The source code has been compiled to program **hello**, when you run it as follows, what `argc` will be?

```
./hello I LOVE CPP
```

> Answer: 4
>
> 4个command line arguments分别是: ./hello, I, LOVE, CPP

#### Q2

The following code is the prototype/declaration of function mul.

```cpp
int mul(int a, int b)
{
    return a * b;
}
```

> Answer: False
>
> 这段代码是定义(definition)而非声明(prototype/declaration)

#### Q3

The data type of the variable `PI` is `double`

```cpp
#define PI 3.14
```

> Answer: False
>
> 宏不是变量(variable)

#### Q4

When a function prototype is declared in the header file you create, you do NOT need to define it in a CPP file.

> Answer: False
>
> 头文件里的声明+CPP文件的定义才能使用函数。

#### Q5

 IDE (Integrated development environment) is a powerful compiler with many userful features.

> Answer: False
>
> 集成开发环境可不只是编译器啊

#### Q6

If you get 75 for one of your projects, which situation should most likely be?

> Answer: Finish all tasks
>
> 为什么要复习这个啊=-=

### Data Types and Arithmetic Operators

#### Q1

```cpp
signed char c1 = 127;
signed char c2 = 1;
int csum = c1 + c2;
cout << csum;
```

What's the output of the source code?

> Answer: 128
>
> 为了计算，先转换成了int再做加法，结果储存进int型变量避免了溢出。
>
> 整数运算只有int和long long两类运算，所以下面那段代码会输出-2147483648，就是先按int型计算溢出后再储存进long long。
>
> ```cpp
> int x = INT_MAX;
> int y = 1;
> long long p = x + y;
> cout << p;
> //output: -2147483648
> ```

#### Q2

`sizeof()` is a function and can yield the size in bytes of a type.

> Answer: False
>
> `sizeof`是个操作符，不是函数！

#### Q3

`size_t` is an unsigned integer type.

> Answer: True
>
> size_t 是无符号整数类型, 32 bit or 64 bit

#### Q4

What's the value of the variable `num`?

```cpp
int num = 23 / 4 * 4;
```

> Answer: 20
>
> (int)23/4=5, (int)5*4=4.

#### Q5

What's the value of variable `num`?

```cpp
int num = 23 / 4. * 4;
```

> Answer: 23
>
> 23/(double)4.=5.75, 5.75*4=(double)23.00, (int)23.00=23

#### Q6

What's the value of variable `num`?

```
int num = 23 / 4 * 4.;
```

> Answer: 20
>
> (int)23/4=5, 5*(double)4.=(double)20.00, (int)20.00=20

#### Q7

 In the following code, since the variable num is not initialized explicitly, it will be initialized to 0 automatically.

```cpp
int num;
std::cout<< num << std::endl;
```

> Answer: False
>
> 在某些平台，未初始化的变量可能拥有随机值

#### Q8

auto is a placeholder type specifier in C++11. What is the value of the variable `val` in the following code?

```cpp
auto val = 2 / 3;
val = 3.14 * 2;
```

> Answer: 6
>
> auto=int

### Branching and Looping Statements

#### Q1

 What's the output of the following source code?

```cpp
int x = 100;
int y = 30;
x+= (y-=10);
cout << x;
```

> Answer: 120
>
> 先执行括号里的，再执行括号外的

#### Q2

What's the output of the following source code?

```cpp
int x = 100;
int y = x++;
cout << y;
```

> Answer: 100
>
> 自增在后，先赋值再自增

#### Q3

What's the output of the following source code:

```cpp
int x = 100;
int y = (x = 200);
cout << y;
```

> Answer: 200
>
> 先执行括号里的，再执行括号外的

#### Q4

 What's the output of the following source code?

```cpp
int a = 2, b = 0;
if (a||b++)
{
    cout << b;
}
```

> Answer: 0
>
> 逻辑短路，自增不执行

#### Q5

What's the output of the following source code?

```cpp
int i = 0;
for(i = 1; i < 100; i+=2)
{
	//something
}
cout << i;
```

> Answer: 101
>
> 循环结束条件i<100不满足时i=101

#### Q6

What's the output of the source code

```cpp
int x = 5;
do
{
    x = 0;
} while( x );
cout << x;
```

> Answer: 0
>
> 执行了一次就润了

#### Q7

The following source code (empty in the parentheses) can be compiled successfully.

```cpp
for()
{
	//some lines here
}
```

> Answer: False
>
> for至少要有条件项

#### Q8

What is the output of the following code?

```cpp
int num = 5;
switch (num)
{
    case '4':
        cout << "Key 4" << endl;
    case '5':
        cout << "Key 5" << endl;
    default:
        cout << "Undefined key." << endl;
}
```

> Answer: Undefined key.
>
> 注意char型的'5'≠int型的5

#### Q9

How many lines will be printed?

```cpp
for(size_t i = 10; i >= 0; i--)
    cout << "Line " << i << endl;
```

> Answer: $\infty$
>
> size_t 自减到负数之后会“溢出”到最大整数，死循环

### Data Structures

#### Q1

What's the output of the source code?

```cpp
int idx = 0;
int numbers[4] = {2, 4, 6, 8};
idx = -1;
cout << numbers[idx] << endl;
return 0;
```

> Answer: Unpredictable result
>
> 负下标越界，编译是能过，运行时要么段错误要么非法访问其他内存

#### Q2

What's the output of the source code?

```cpp
int idx = 0;
int numbers[4] = {2, 4, 6, 8};
idx = 4;
cout << numbers[idx] << endl;
return 0;
```

> Answer: Unpredictable result
>
> 下标越界，编译是能过，运行时要么段错误要么非法访问其他内存

#### Q3

What's the output if you compile the following source code with C++11 standard?

```cpp
string str{"hello"};
cout << str[1] << endl;
```

> Answer: e
>
> str[1]是第二个元素

#### Q4

What's the output?

```cpp
char str[16] = {"C++"};
cout << strlen(str) << endl;
```

> Answer: 3
>
> 赋值的时候末尾带了个'\0'，strlen读到'\0'就停了

#### Q5

What's the output?

```cpp
char str1[16] = {"C++"};
char str2[16];
str2 = str1;
cout << str2 << endl;
```

> Answer: Compilation error.
>
> 数组相当于常量指针，不能直接对其赋值

#### Q6

What's the output?

```cpp
string str1 = {"C++"};
string str2;
str2 = str1;
cout << str2 << endl;
```

> Answer: C++
>
> 但是string可以直接赋值

#### Q7

What's the output?

```cpp
union twonumbers
{
    int n[2];
    double d;
};

int main()
{
    twonumbers tn;
    tn.d = 1.23;
    tn.n[0] = 0;
    tn.n[1] = 0;
    cout << tn.d << endl;
    return 0;
}
```

> Answer: 0
>
> union各成员共用一块内存，所占用的内存长度等于最长的成员的内存长度，通过n修改为0后用d访问也是0

#### Q8

The output of the following code is:

```cpp
struct Person
{
    bool male;
    int id;
    char label;
};
std::cout << sizeof(struct Person);
```

> Answer: 12
>
> 虽然bool和char都只占用一字节，但被占用4字节的int分隔开，结构体会为了对齐而给bool和char也分配4字节，总共12字节

### Pointers and Dynamic Memory Management

#### Q1

The following code can be compiled successfuly.

```cpp
double value = 0.0;
double *const p = &value;
p[0] = 2.0;
```

> Answer: True
>
> type *const代表指针是常量，但指针所指的数据可以修改

#### Q2

The following source code is correct and cannot cause bugs.

```cpp
int *pint = (int *)malloc(8 * sizeof(int));
char *pc = (char *)pint;
pc[8] = 'a';
*(pc + 8) = 'b';
```

> Answer: True
>
> 指针类型的转换，通过指针操作内存均合法，没有越界等问题

#### Q3

The following code can be compiled successfuly.

```cpp
double value = 0.0;
const double *p = &value;
value = 2.0;
```

> Answer: True
>
> const type *p和type const *p表示指针所指内容是常量，无法通过指针更改
>
> 但可以通过其他方式修改内容

#### Q4

The following source code is correct.

```cpp
int *ptr;
*ptr = 3;
```

> Answer: False
>
> 不能对未分配内存的指针进行赋值

#### Q5

What's the output of the following code on 64bit OS and CPU?

```cpp
int *numbers = new int[8];
cout << sizeof(numbers) << endl;
```

> Answer: 8
>
> 64位环境下，指针长度为8字节

#### Q6

What's the output of the following code?

```cpp
int *numbers = new int[8];
char *pc = (char *)numbers;
*numbers = 0x0A0B0C0D;
cout << (int)pc[3] << endl;
```

> Answer: 10
>
> 第三行给number[0]赋值0x0A0B0C0D，一个int对应四个char，pc[3]代表其中第四个字节，即0x0A，转换后为10

#### Q7

What's the output of the following code on 64bit OS and CPU?

```cpp
int numbers[8];
cout << sizeof(numbers) << endl;
```

> Answer: 32
>
> 对于数组，sizeof会返回其所指内存的大小

### Basics of Functions

#### Q1

What's the output of the following code?

```cpp
float foo(float *p, int n)
{
    p[0] = 1.0f;
}
int main()
{
    float values[4] = {3.0f, 4.0f, 5.0f, 6.0f};
    foo(values + 2, 2);
    cout << *values << " ";
    cout << *values + 2 << " ";
    cout << *(values + 2) << " ";
    cout << values[2] << endl;
    return 0;
}
```

> Answer: 3 5 1 1
>
> 四个数分别为 v[0], v[0]+2, v[2], v[2]，注意优先级

#### Q2

What's the output of the following source code?

```cpp
struct people
{
    string name;
    int age;
};
void init(people &p)
{
    p.name = "No name";
    p.age = 0;
}
int main()
{
    people p;
    p.age = -1;
    init(p);
    cout << p.age << endl;
    return 0;
}
```

> Answer: 0
>
> p作为引用参数传入init，age被修改为0

#### Q3

What's the output?

```cpp
int area(int &x)
{
    return x *= x;
}
int main()
{
    int n = 10;
    area(n);
    std::cout << n << std::endl;
}
```

> Answer: 100
>
> n作为引用参数传入area，乘方

#### Q4

What's the output of the following code?

```cpp
struct people
{
    string name;
    int age;
};
void init(people *p)
{
    p.name = "No name";
    p.age = 0;
}
int main()
{
    people p;
    p.age = -1;
    init(p);
    cout << p.age << endl;
    return 0;
}
```

> Answer: Compilation error
>
> init函数要求传入指针，但传入的是people结构体变量

#### Q5

What's the output of the following code?

```cpp
float area(float &x)
{
    return x * x;
}
int main()
{
    float value = 3.0f;
    cout << area(value);
}
```

> Answer: 9
>
> 3.0f*3.0f=9.0f

#### Q6

 What's the output of the following code?

```cpp
float area(float &x)
{
    x = x * x;
    return x;
}
int main()
{
    float value = 3.0f;
    cout << area(value) << " ";
    cout << value << endl;
    return 0;
}
```

> Answer: 9 9
>
> 通过引用修改了x，并返回了修改后的x

#### Q7

What's the ouput of function sum()?

```cpp
int main()
{
    int cookies[8] = {1, 2, 4, 8, 16, 32, 64, 128};
    int n = sum(cookies, 3);
}
int sum(int arr[], int n)
{
    std::cout << sizeof arr;
    return 0;
}
```

> Answer: 4 or 8
>
> 传入参数实际上是指针，指针占用字节数可能是4或8

#### Q8

What's the output of the following code?

```cpp
float area(float *x)
{
    return *x * *x;
}
int main()
{
    float value = 3.0f;
    cout << area(value);
}
```

> Answer: Compilation error
>
> 要求传入浮点型指针，实际传入浮点型变量

#### Q9

What's the output of the following code?

```cpp
struct people
{
    string name;
    int age;
};
void init(people p)
{
    p.name = "No name";
    p.age = 0;
}
int main()
{
    people p;
    p.age = -1;
    init(p);
    cout << p.age << endl;
    return 0;
}
```

> Answer: -1
>
> 函数参数是结构体变量，在传入后是对变量的拷贝进行操作，不影响变量本身

#### Q10

 What's the output of the following code?

```cpp
struct people
{
    string name;
    int age;
};
void init(people *p)
{
    p->name = "No name";
    p->age = 0;
}
int main()
{
    people p;
    p.age = -1;
    init(&p);
    cout << p.age << endl;
    return 0;
}
```

> Answer: 0
>
> 传入参数是指针，通过指针对结构体成员变量age进行操作

### Advances in Functions

#### Q1

 The following declaration correctly defines some default arguments

```cpp
int harpo(int n = 3, int m, int k = 3);
```

> Answer: False
>
> 所有默认参数必须集中放在最后

#### Q2

The functions and a function pointer are declared as follows. Which answers are correct?

```cpp
float norm(float x, float y); // declaration
float (*norm_ptr)(float x, float y); // norm_ptr is a function pointer
```

> Answer: 
>
> ```cpp
> norm_ptr = &norm;
> (*norm_ptr)(-3.0f, 4.0f);
> norm_ptr(-3.0f, 4.0f);
> norm_ptr = norm;
> (*norm_ptr)(-3.0f, 4.0f);
> norm_ptr(-3.0f, 4.0f);
> ```
>
> 大概意思就是函数指针和函数名在使用时可以适当混用

#### Q3

Function overloading is that multiple functions share the same function name but different signatures as the two functions below:

```cpp
float foo(float arg);
int foo(double arg);
```

> Answer: True
>
> 你说得对

#### Q4

There is a function template. The specialization is correctly implemented in the following code.

```cpp
template <typename T>
T sum(T x, T y)
{
    cout << "The input type is " << typeid(T).name() << endl;
    return x + y;
}
struct Point
{
    int x;
    int y;
};
// Specialization for Point + Point operation
template
Point sum<Point>(Point pt1, Point pt2)
{
    cout << "The input type is " << typeid(pt1).name() << endl;
    Point pt;
    pt.x = pt1.x + pt2.x;
    pt.y = pt1.y + pt2.y;
    return pt;
}
```

> Answer: False
>
> 特例化应该这么写：
>
> ```cpp
> template<>
> Point sum(Point pt1, Point pt2)
> ```

#### Q5

The following code correctly defines a function template:

```cpp
template <typename T> 
void swap(T &a, T &b)
{
    T temp; 
    temp = a;
    a = b;
    b = temp;
}
```

> Answer: True
>
> 你说得对

### Basics of Classes

#### Q1

The **this** pointer points to the object and can be used to invoke a member as in the following code.

```cpp
class Person
{
    int num;    
public:
    static int foo()
    {
        return this->num;
    }
    //other members
};
```

> Answer: False
>
> 静态函数无法调用非静态对象的成员，逻辑上不可行

#### Q2

What's the output of the following code?

```cpp
class Person
{
    string name;
};
int main()
{
    Person p;
    p.name = "No name";
    cout << p.name;
    return 0;
}
```

> Answer: Compilation error
>
> class成员在未声明为public时默认private，无法被外部直接调用

#### Q3

What's the output of the source code?

```cpp
class Hello
{
    static int value;
    int num;
public:
    int sum(int i, int j) { return i + j; }
    void setValue(int v) { value = v; }
    int getValue() { return value; }
};
int main()
{
    Hello h1, h2;
    h1.setValue(5);
    cout << h2.getValue() << endl;
    return 0;
}
```

> Answer: Link error
>
> 在对类的静态变量做操作前，需要先在类外进行定义。

#### Q4

A class is declared as follows. Please select correct answers for creating a variable.

```cpp
class Stock
{
public:
    Stock(); 
    Stock(const std::string &co, long n = 0, double pr = 0.0);
    ~Stock(); 
    //other members
};
```

> Answer: 
>
> ```cpp
> Stock st1;//OK
> Stock st2("A",3,2.0f);//OK
> Stock st3 = Stock("A",3,2.0f);//OK
> Stock st4 = ("A",,2.0f);//Error
> ```
>
> 无参构造器，含参构造器，默认参数不能间隔省略

#### Q5

 What's the output of the following source code?

```cpp
class Hello
{
    static int value;
    int num;
public:
    int sum(int i, int j) { return i + j; }
};
int main()
{
    cout << sizeof(Hello) << endl;
    return 0;
}
```

> Answer: 4
>
> 用sizeof对类进行操作时，其大小为对齐后的非静态成员数据的类型大小之和
>
> 如果是空类，占1字节
>
> 如果含有虚函数，则额外占有4字节虚函数表大小
>
> 与构造、析构函数等成员函数、静态变量无关

### Advances in Classes

#### Q1

Class Stonewt is declared as follows. 

```cpp
class Stonewt
{
   //some members
public:
    Stonewt(double lbs);
    Stonewt(int stn, double lbs);
    Stonewt();
    ~Stonewt();
    operator int() const;
    operator double() const;
};
```

Which function will be invoked by the following line of code ?

```cpp
Stonewt wt = 120;
```

> Answer: Stonewt(double lbs);
>
> 隐式转换后调用上述构造器，决定用哪个构造器发生在编译过程

#### Q2

Class Stonewt is declared as above. 

Which function will be invoked by the following line of code ?

```cpp
Stonewt wt(120);
```

>Answer: Stonewt(double lbs);
>
>~~梅开二度~~

#### Q3

Class Stonewt is declared as above. 

Which function will be invoked by the following line of code ?

```cpp
wt = 120.0; //wt is an object of type Stonewt
```

> Answer: Stonewt(double lbs);
>
> ~~三连加关注，CS不迷路~~

#### Q4

Class Stonewt is declared as above. 

Which function will be invoked by the following line of code ?

```cpp
double f = wt; //wt is an object of type Stonewt
```

> Answer: operator double() const;
>
> 隐式转换再赋值

#### Q5

We can change operators' precedence by overloading.

> Answer: False
>
> 运算含义可以改，但优先级改不了

#### Q6

If we define a memeber function as follows for class Time

```cpp
Time Time::operator*(double mult) const
```

then we can calculate as follows

```cpp
a = 3.3 * b;//a and b are objects of type Time
```

> Answer: False
>
> 重载的乘号，左边Time右边double，反过来不行

#### Q7

Assignment operator '=' can be overloaded by a non-member function.

> Answer: False
>
> 赋值符是一个特例，只能作为成员函数被重载

#### Q8

If the friend function is defined as in the following source code, it is a member function in the class.

```cpp
class Time
{
private:
    int hours;
    int minutes;
public:
    Time();
    Time(int h, int m = 0);
    void AddMin(int m);
    void AddHr(int h);
    void Reset(int h = 0, int m = 0);
    Time operator+(const Time &t) const;
    Time operator-(const Time &t) const;
    Time operator*(double n) const;
    void Show() const;
    friend Time operator*(double mult, Time in);
};
```

> Answer: False
>
> 友元函数需要在类内声明，私有公有没区别，也可以在类内定义，但友元终究不是成员

#### Q9

operator+() overloads the + operator, and it can only be used for mathematical addition.

> Answer: False
>
> 你想把加号重载成乘法运算符也没人拦你（

#### Q10

A conversion function is defined outside of the declaration of class Stonewt as follow.

```cpp
Stonewt::operator double() const
{
    return pounds;
}
```

> Answer: It's correctly defined.
>
> 冇问题

### Dynamic Memory Management in Classes

#### Q1

Please read the following code and choose correct answers:

```cpp
class Person
{
    char *name;
public:
    Person()
    {
        name = new char[128];
    }
    ~Person()
    {
        delete name;
    }
};
int main()
{
    Person p1;
    Person p2;
    p1 = p2;
    return 0;
}
```

> Answer: 
>
> - The code can be compiled without error.
> - Runtime error.
> - It can cause memory double free problem.
> - It can cause memory leak.
>
> 编译是能过，但是由于p1和p2的析构函数会对name做两次delete，所以会双重释放运行错误，而且p1原本申请的char[128]会没有指针指向它，所以会有内存泄漏风险

#### Q2

If you do not define a default constructor for a class explicitly, then no default constructor for that class.

> Answer: False
>
> 如果你没有显式定义任何一个构造器，类会隐含一个默认无参构造器

#### Q3

If assignment operator is not defined in class Person, the following code will invoke default assignment operator.

```cpp
p1 = p2 = p3; //p1, p2 and p3 are objects of type Person
```

> Answer: True
>
> 如果没有重载赋值符，则会调用默认赋值符

#### Q4

For class Person, which of the constructors is its default constructor?

> Answer: 
>
> ```cpp
> Person::Person(int n = 0);
> ```
>
> 有参数，但是所有参数都有默认值，就是默认构造器

#### Q5

You can define two constructors as follows for class Person

```cpp
Person(){...}
Person(int m = 0) {...}
```

> Answer: False
>
> 那么问题来了，猜猜看Person()会调用哪个？

#### Q6

For class Person, which of the constructors is a copy constructor?

> Answer:
>
> ```cpp
> Person::Person(const Person & p);
> ```
>
> 将常量引用作为参数的构造器是复制构造器

### Class Inheritance

#### Q1

 What's the output?

```cpp
class Animal
{
private:
    int weight;
public:
    Animal(int w = 0)
    {
        weight = w;
    }
    virtual void print()
    {
        cout << weight << endl;
    }
};
class Dog : public Animal
{
public:
    Dog(int w = 0) : Animal(w) {}
    void print()
    {
        cout << "Dog ";
        Animal::print();
    }
    void speak()
    {
        cout << "wangwang" << endl;
    }
};
int main()
{
    Dog dog(5);
    Animal *p = &dog;
    p->print();
    return 0;
}
```

> Answer: Dog 5
>
> 由于覆写了虚函数print()，主函数语句调用的是Dog::print()，而Dog::print()再调用了Animal::print()

#### Q2

What is the output?

```cpp
class Animal
{
private:
    int weight;
public:
    Animal(int w = 0)
    {
        weight = w;
    }
    void print()
    {
        cout << weight << endl;
    }
};
class Dog : public Animal
{
public:
    Dog(int w = 0) : Animal(w) {}
    void print()
    {
        cout << "Dog ";
        Animal::print();
    }
    void speak()
    {
        cout << "wangwang" << endl;
    }
};
int main()
{
    Dog dog(5);
    Animal *p = &dog;
    p->print();
    return 0;
}
```

> Answer: 5
>
> 由于p是Animal类，其成员函数均为Animal类中的定义

#### Q3

What is the output?

```cpp
class Animal
{
private:
    int weight;
public:
    Animal(int w = 0)
    {
        weight = w;
    }
    void print()
    {
        cout << weight << endl;
    }
};
class Dog : public Animal
{
public:
    Dog(int w = 0) : Animal(w) {}
    void print()
    {
        cout << "Dog ";
        Animal::print();
    }
    void speak()
    {
        cout << "wangwang" << endl;
    }
};
int main()
{
    Dog dog(5);
    Animal *p = &dog;
    p->speak();
    return 0;
}
```

> Answer: Compilation error
>
> p是Animal类对象，speak()是其子类的函数，p的成员函数编译时静态绑定至Animal定义，因此p未定义speak()函数。

### Class Templates and std Library

#### Q1

Please choose the right answer(s) for declaring a class template

> Answer: 
>
> ```cpp
> template  <class Type>
> class ClassName{...}
> template  <typename Type>
> class ClassName{...}
> ```
>
> 本来是class的，在众人要求下添加了typename关键字，于是两个都能用

#### Q2

Matx and Matx12f are declared in the following figure. Please choose the correct statement(s).

![image.png](https://s2.loli.net/2023/01/09/yTuULq2IAljWaFz.png)

> Answer: Matx is a class tempate, Matx12f is a template class.
>
> 不准确地来说，模板类是由类模板衍生出的类

### Error Handling

#### Q1

A try block can be followed by multiple catch blocks.

> Answer: True
>
> 你说得对，而且catch括号内的类型不会隐式转换，但是子类可以被父类catch

#### Q2

The following source code **cannot** be compiled successfully.

```cpp
double gmean(double a, double b)
{
    if (a < 0 || b < 0)
        throw string("bad arguments");
    return std::sqrt(a*b);
}
int main()
{
    try
    {
        gmean(3, -3);
    }
}
```

> Answer: True
>
> 没有catch的try是不完整的

#### Q3

 The following code **cannot** be compiled successfully since 'try' is commented.

```cpp
double gmean(double a, double b)
{
    if (a < 0 || b < 0)
        throw string("bad arguments");
    return std::sqrt(a*b);
}
int main()
{
    //try
    //{
        gmean(3, -3);
    //}
}
```

> Answer: False
>
> throw了可以不try-catch，不过一抛就终止运行而已

#### Q4

When an exception is thrown, the program must be terminated.

> Answer: False
>
> 如果抛的异常被catch住了，程序就可以继续运行catch内的内容