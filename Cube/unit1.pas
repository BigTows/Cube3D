unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls;

type
  Matrix3D = array [1..4] of real;

  World3D = record
    X1: real;
    X2: real;
    Y1: real;
    Y2: real;
    Z1: real;
    Z2: real;
  end;

  Matrix2D = array [1..2] of integer; // For Screen

  Scene = record
    X1: integer;
    X2: integer;
    Y1: integer;
    Y2: integer;
  end;

  { TForm1 }

  TForm1 = class(TForm)
    Image1: TImage;
    Timer1: TTimer;
    procedure FormCreate(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: char);
    procedure Image1Click(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end;

function RotateX(Test: Matrix3D; Fi: real): Matrix3D;
function RotateY(Test: Matrix3D; Fi: real): Matrix3D;
function RotateZ(Test: Matrix3D; Fi: real): Matrix3D;
function To2D(Test: Matrix3D): Matrix2D;
function GetNewCords(Cords:Matrix3D):Matrix3D;
procedure Clean();
procedure Leftss();
var
  Form1: TForm1;
  World: World3D;
  Screen: Scene;
  s: real;
  FiRotateX,FiRotateZ,FiRotateY:real;
  MotionX,MotionY,MotionZ:real;
  Cube: Matrix3D;
  Te, T2, T3: Matrix2D;
  UserCords:Matrix3D;
implementation

{$R *.lfm}

{ TForm1 }
 function GetNewCords(Cords:Matrix3D):Matrix3D;
 begin
   GetNewCords[1]:=1*Cords[1]+UserCords[1]*Cords[4];
   GetNewCords[2]:=1*Cords[2]+UserCords[2]*Cords[4];
   GetNewCords[3]:=1*Cords[3]+UserCords[3]*Cords[4];
   GetNewCords[4]:=UserCords[4]*Cords[4];
 end;

function RotateX(Test: Matrix3D; Fi: real): Matrix3D;
begin
  RotateX[1] := Test[1] * 1;
  RotateX[2] := Test[2] * cos(Fi) + (Test[3] * -sin(Fi));
  RotateX[3] := Test[2] * sin(Fi) + (Test[3] * cos(Fi));
  RotateX[4] := Test[4] * 1;
end;

function RotateY(Test: Matrix3D; Fi: real): Matrix3D;
begin
  RotateY[1] := cos(Fi) * Test[1] + (-sin(fi) * Test[3]);
  RotateY[2] := Test[2] * 1;
  RotateY[3] := sin(Fi) * Test[1] + cos(Fi) * Test[3];
  RotateY[4] := Test[4] * 1;
end;

function RotateZ(Test: Matrix3D; Fi: real): Matrix3D;
begin
  RotateZ[1] := cos(fi) * Test[1] + (-sin(Fi) * Test[2]);
  RotateZ[2] := Sin(fi) * Test[1] + (cos(fi) * Test[2]);
  RotateZ[3] := Test[3] * 1;
  RotateZ[4] := Test[4] * 1;
end;

function To2D(Test: Matrix3D): Matrix2D;
begin
  To2D[1] := Trunc(((Screen.X2 - Screen.X1) / (World.X2 - World.X1)) * Test[1] +
    (Screen.X1 - (World.X1 * (Screen.X2 - Screen.X1) / (World.X2 - World.X1))));
  To2D[2] := Trunc((-Screen.Y2 - Screen.Y1) / (World.Y2 - World.Y1) * Test[2] +
    (Screen.Y2 - (World.Y1 * (Screen.Y2 - Screen.Y1) / (World.Y2 - World.Y1))));
end;

procedure Clean();
begin
  Form1.Image1.Canvas.Pen.Color := clBlack;
  //DOWN
  Cube[1] := 4;
  Cube[2] := 0;
  Cube[3] := 0;
  Cube[4] := 1;
  Te := To2D(RotateZ(RotateY(RotateX(GetNewCords(Cube),FiRotateX),FiRotateY),FiRotateZ));
  Cube[1] := 0;
  Cube[2] := 0;
  Cube[3] := 0;
  Cube[4] := 1;
  T2 := To2D(RotateZ(RotateY(RotateX(GetNewCords(Cube),FiRotateX),FiRotateY),FiRotateZ));
  Form1.Image1.Canvas.Line(Te[1], Te[2], T2[1], T2[2]);


    //Left
  Cube[1] := 0;
  Cube[2] := 0;
  Cube[3] := 0;
  Cube[4] := 1;
  Te := To2D(RotateZ(RotateY(RotateX(GetNewCords(Cube),FiRotateX),FiRotateY),FiRotateZ));
  Cube[1] := 0;
  Cube[2] := 0;
  Cube[3] := 4;
  Cube[4] := 1;
  T2 := To2D(RotateZ(RotateY(RotateX(GetNewCords(Cube),FiRotateX),FiRotateY),FiRotateZ));
  Form1.Image1.Canvas.Line(Te[1], Te[2], T2[1], T2[2]);

    //Mid
  Cube[1] := 0;
  Cube[2] := 0;
  Cube[3] := 0;
  Cube[4] := 1;
  Te := To2D(RotateZ(RotateY(RotateX(GetNewCords(Cube),FiRotateX),FiRotateY),FiRotateZ));
  Cube[1] := 0;
  Cube[2] := 4;
  Cube[3] := 0;
  Cube[4] := 1;
  T2 := To2D(RotateZ(RotateY(RotateX(GetNewCords(Cube),FiRotateX),FiRotateY),FiRotateZ));
  Form1.Image1.Canvas.Line(Te[1], Te[2], T2[1], T2[2]);

      //TopDOWN
  Cube[1] := 0;
  Cube[2] := 4;
  Cube[3] := 0;
  Cube[4] := 1;
  Te := To2D(RotateZ(RotateY(RotateX(GetNewCords(Cube),FiRotateX),FiRotateY),FiRotateZ));
  Cube[1] := 4;
  Cube[2] := 4;
  Cube[3] := 0;
  Cube[4] := 1;
  T2 := To2D(RotateZ(RotateY(RotateX(GetNewCords(Cube),FiRotateX),FiRotateY),FiRotateZ));
  Form1.Image1.Canvas.Line(Te[1], Te[2], T2[1], T2[2]);

      //TOPLeft
  Cube[1] := 0;
  Cube[2] := 4;
  Cube[3] := 0;
  Cube[4] := 1;
  Te := To2D(RotateZ(RotateY(RotateX(GetNewCords(Cube),FiRotateX),FiRotateY),FiRotateZ));
  Cube[1] := 0;
  Cube[2] := 4;
  Cube[3] := 4;
  Cube[4] := 1;
  T2 := To2D(RotateZ(RotateY(RotateX(GetNewCords(Cube),FiRotateX),FiRotateY),FiRotateZ));
  Form1.Image1.Canvas.Line(Te[1], Te[2], T2[1], T2[2]);



        //TOPLeftDOWN
  Cube[1] := 0;
  Cube[2] := 4;
  Cube[3] := 4;
  Cube[4] := 1;
  Te := To2D(RotateZ(RotateY(RotateX(GetNewCords(Cube),FiRotateX),FiRotateY),FiRotateZ));
  Cube[1] := 0;
  Cube[2] := 0;
  Cube[3] := 4;
  Cube[4] := 1;
  T2 := To2D(RotateZ(RotateY(RotateX(GetNewCords(Cube),FiRotateX),FiRotateY),FiRotateZ));
  Form1.Image1.Canvas.Line(Te[1], Te[2], T2[1], T2[2]);

          //TOPUPD
  Cube[1] := 0;
  Cube[2] := 4;
  Cube[3] := 4;
  Cube[4] := 1;
  Te := To2D(RotateZ(RotateY(RotateX(GetNewCords(Cube),FiRotateX),FiRotateY),FiRotateZ));
  Cube[1] := 4;
  Cube[2] := 4;
  Cube[3] := 4;
  Cube[4] := 1;
  T2 := To2D(RotateZ(RotateY(RotateX(GetNewCords(Cube),FiRotateX),FiRotateY),FiRotateZ));
  Form1.Image1.Canvas.Line(Te[1], Te[2], T2[1], T2[2]);

          //TOPLeftDOWN  true 22
  Cube[1] := 4;
  Cube[2] := 0;
  Cube[3] := 0;
  Cube[4] := 1;
  Te := To2D(RotateZ(RotateY(RotateX(GetNewCords(Cube),FiRotateX),FiRotateY),FiRotateZ));
  Cube[1] := 4;
  Cube[2] := 4;
  Cube[3] := 0;
  Cube[4] := 1;
  T2 := To2D(RotateZ(RotateY(RotateX(GetNewCords(Cube),FiRotateX),FiRotateY),FiRotateZ));
  Form1.Image1.Canvas.Line(Te[1], Te[2], T2[1], T2[2]);

            //TOPLeftDOWN
  Cube[1] := 4;
  Cube[2] := 4;
  Cube[3] := 4;
  Cube[4] := 1;
  Te := To2D(RotateZ(RotateY(RotateX(GetNewCords(Cube),FiRotateX),FiRotateY),FiRotateZ));
  Cube[1] := 4;
  Cube[2] := 0;
  Cube[3] := 4;
  Cube[4] := 1;
  T2 := To2D(RotateZ(RotateY(RotateX(GetNewCords(Cube),FiRotateX),FiRotateY),FiRotateZ));
  Form1.Image1.Canvas.Line(Te[1], Te[2], T2[1], T2[2]);

            //TOPLeftDOWN
  Cube[1] := 4;
  Cube[2] := 0;
  Cube[3] := 4;
  Cube[4] := 1;
  Te := To2D(RotateZ(RotateY(RotateX(GetNewCords(Cube),FiRotateX),FiRotateY),FiRotateZ));
  Cube[1] := 4;
  Cube[2] := 0;
  Cube[3] := 0;
  Cube[4] := 1;
  T2 := To2D(RotateZ(RotateY(RotateX(GetNewCords(Cube),FiRotateX),FiRotateY),FiRotateZ));
  Form1.Image1.Canvas.Line(Te[1], Te[2], T2[1], T2[2]);

              //TOPLeftDOWN
  Cube[1] := 4;
  Cube[2] := 0;
  Cube[3] := 4;
  Cube[4] := 1;
  Te := To2D(RotateZ(RotateY(RotateX(GetNewCords(Cube),FiRotateX),FiRotateY),FiRotateZ));
  Cube[1] := 0;
  Cube[2] := 0;
  Cube[3] := 4;
  Cube[4] := 1;
  T2 := To2D(RotateZ(RotateY(RotateX(GetNewCords(Cube),FiRotateX),FiRotateY),FiRotateZ));
  Form1.Image1.Canvas.Line(Te[1], Te[2], T2[1], T2[2]);

              //TOPLeftDOWN true
  Cube[1] := 4;
  Cube[2] := 4;
  Cube[3] := 0;
  Cube[4] := 1;
  Te := To2D(RotateZ(RotateY(RotateX(GetNewCords(Cube),FiRotateX),FiRotateY),FiRotateZ));
  Cube[1] := 4;
  Cube[2] := 4;
  Cube[3] := 4;
  Cube[4] := 1;
  T2 := To2D(RotateZ(RotateY(RotateX(GetNewCords(Cube),FiRotateX),FiRotateY),FiRotateZ));
  Form1.Image1.Canvas.Line(Te[1], Te[2], T2[1], T2[2]);

                //TOPLeftDOWN
  Cube[1] := 4;
  Cube[2] := 0;
  Cube[3] := 0;
  Cube[4] := 1;
  Te := To2D(RotateZ(RotateY(RotateX(GetNewCords(Cube),FiRotateX),FiRotateY),FiRotateZ));
  Cube[1] := 4;
  Cube[2] := 0;
  Cube[3] := 4;
  Cube[4] := 1;
  T2 := To2D(RotateZ(RotateY(RotateX(GetNewCords(Cube),FiRotateX),FiRotateY),FiRotateZ));
  Form1.Image1.Canvas.Line(Te[1], Te[2], T2[1], T2[2]);
end;

procedure Leftss();
begin
  Form1.Image1.Canvas.Pen.Color := clGreen;
  //DOWN
  Cube[1] := 4;
  Cube[2] := 0;
  Cube[3] := 0;
  Cube[4] := 1;
  Te := To2D(RotateZ(RotateY(RotateX(GetNewCords(Cube),FiRotateX),FiRotateY),FiRotateZ));
  Cube[1] := 0;
  Cube[2] := 0;
  Cube[3] := 0;
  Cube[4] := 1;
  T2 := To2D(RotateZ(RotateY(RotateX(GetNewCords(Cube),FiRotateX),FiRotateY),FiRotateZ));
  Form1.Image1.Canvas.Line(Te[1], Te[2], T2[1], T2[2]);


    //Left
  Cube[1] := 0;
  Cube[2] := 0;
  Cube[3] := 0;
  Cube[4] := 1;
  Te := To2D(RotateZ(RotateY(RotateX(GetNewCords(Cube),FiRotateX),FiRotateY),FiRotateZ));
  Cube[1] := 0;
  Cube[2] := 0;
  Cube[3] := 4;
  Cube[4] := 1;
  T2 := To2D(RotateZ(RotateY(RotateX(GetNewCords(Cube),FiRotateX),FiRotateY),FiRotateZ));
  Form1.Image1.Canvas.Line(Te[1], Te[2], T2[1], T2[2]);

    //Mid
  Cube[1] := 0;
  Cube[2] := 0;
  Cube[3] := 0;
  Cube[4] := 1;
  Te := To2D(RotateZ(RotateY(RotateX(GetNewCords(Cube),FiRotateX),FiRotateY),FiRotateZ));
  Cube[1] := 0;
  Cube[2] := 4;
  Cube[3] := 0;
  Cube[4] := 1;
  T2 := To2D(RotateZ(RotateY(RotateX(GetNewCords(Cube),FiRotateX),FiRotateY),FiRotateZ));
  Form1.Image1.Canvas.Line(Te[1], Te[2], T2[1], T2[2]);

      //TopDOWN
  Cube[1] := 0;
  Cube[2] := 4;
  Cube[3] := 0;
  Cube[4] := 1;
  Te := To2D(RotateZ(RotateY(RotateX(GetNewCords(Cube),FiRotateX),FiRotateY),FiRotateZ));
  Cube[1] := 4;
  Cube[2] := 4;
  Cube[3] := 0;
  Cube[4] := 1;
  T2 := To2D(RotateZ(RotateY(RotateX(GetNewCords(Cube),FiRotateX),FiRotateY),FiRotateZ));
  Form1.Image1.Canvas.Line(Te[1], Te[2], T2[1], T2[2]);

      //TOPLeft
  Cube[1] := 0;
  Cube[2] := 4;
  Cube[3] := 0;
  Cube[4] := 1;
  Te := To2D(RotateZ(RotateY(RotateX(GetNewCords(Cube),FiRotateX),FiRotateY),FiRotateZ));
  Cube[1] := 0;
  Cube[2] := 4;
  Cube[3] := 4;
  Cube[4] := 1;
  T2 := To2D(RotateZ(RotateY(RotateX(GetNewCords(Cube),FiRotateX),FiRotateY),FiRotateZ));
  Form1.Image1.Canvas.Line(Te[1], Te[2], T2[1], T2[2]);



        //TOPLeftDOWN
  Cube[1] := 0;
  Cube[2] := 4;
  Cube[3] := 4;
  Cube[4] := 1;
  Te := To2D(RotateZ(RotateY(RotateX(GetNewCords(Cube),FiRotateX),FiRotateY),FiRotateZ));
  Cube[1] := 0;
  Cube[2] := 0;
  Cube[3] := 4;
  Cube[4] := 1;
  T2 := To2D(RotateZ(RotateY(RotateX(GetNewCords(Cube),FiRotateX),FiRotateY),FiRotateZ));
  Form1.Image1.Canvas.Line(Te[1], Te[2], T2[1], T2[2]);

          //TOPUPD
  Cube[1] := 0;
  Cube[2] := 4;
  Cube[3] := 4;
  Cube[4] := 1;
  Te := To2D(RotateZ(RotateY(RotateX(GetNewCords(Cube),FiRotateX),FiRotateY),FiRotateZ));
  Cube[1] := 4;
  Cube[2] := 4;
  Cube[3] := 4;
  Cube[4] := 1;
  T2 := To2D(RotateZ(RotateY(RotateX(GetNewCords(Cube),FiRotateX),FiRotateY),FiRotateZ));
  Form1.Image1.Canvas.Line(Te[1], Te[2], T2[1], T2[2]);

          //TOPLeftDOWN  true 22
  Cube[1] := 4;
  Cube[2] := 0;
  Cube[3] := 0;
  Cube[4] := 1;
  Te := To2D(RotateZ(RotateY(RotateX(GetNewCords(Cube),FiRotateX),FiRotateY),FiRotateZ));
  Cube[1] := 4;
  Cube[2] := 4;
  Cube[3] := 0;
  Cube[4] := 1;
  T2 := To2D(RotateZ(RotateY(RotateX(GetNewCords(Cube),FiRotateX),FiRotateY),FiRotateZ));
  Form1.Image1.Canvas.Line(Te[1], Te[2], T2[1], T2[2]);

            //TOPLeftDOWN
  Cube[1] := 4;
  Cube[2] := 4;
  Cube[3] := 4;
  Cube[4] := 1;
  Te := To2D(RotateZ(RotateY(RotateX(GetNewCords(Cube),FiRotateX),FiRotateY),FiRotateZ));
  Cube[1] := 4;
  Cube[2] := 0;
  Cube[3] := 4;
  Cube[4] := 1;
  T2 := To2D(RotateZ(RotateY(RotateX(GetNewCords(Cube),FiRotateX),FiRotateY),FiRotateZ));
  Form1.Image1.Canvas.Line(Te[1], Te[2], T2[1], T2[2]);

            //TOPLeftDOWN
  Cube[1] := 4;
  Cube[2] := 0;
  Cube[3] := 4;
  Cube[4] := 1;
  Te := To2D(RotateZ(RotateY(RotateX(GetNewCords(Cube),FiRotateX),FiRotateY),FiRotateZ));
  Cube[1] := 4;
  Cube[2] := 0;
  Cube[3] := 0;
  Cube[4] := 1;
  T2 := To2D(RotateZ(RotateY(RotateX(GetNewCords(Cube),FiRotateX),FiRotateY),FiRotateZ));
  Form1.Image1.Canvas.Line(Te[1], Te[2], T2[1], T2[2]);

              //TOPLeftDOWN
  Cube[1] := 4;
  Cube[2] := 0;
  Cube[3] := 4;
  Cube[4] := 1;
  Te := To2D(RotateZ(RotateY(RotateX(GetNewCords(Cube),FiRotateX),FiRotateY),FiRotateZ));
  Cube[1] := 0;
  Cube[2] := 0;
  Cube[3] := 4;
  Cube[4] := 1;
  T2 := To2D(RotateZ(RotateY(RotateX(GetNewCords(Cube),FiRotateX),FiRotateY),FiRotateZ));
  Form1.Image1.Canvas.Line(Te[1], Te[2], T2[1], T2[2]);

              //TOPLeftDOWN true
  Cube[1] := 4;
  Cube[2] := 4;
  Cube[3] := 0;
  Cube[4] := 1;
  Te := To2D(RotateZ(RotateY(RotateX(GetNewCords(Cube),FiRotateX),FiRotateY),FiRotateZ));
  Cube[1] := 4;
  Cube[2] := 4;
  Cube[3] := 4;
  Cube[4] := 1;
  T2 := To2D(RotateZ(RotateY(RotateX(GetNewCords(Cube),FiRotateX),FiRotateY),FiRotateZ));
  Form1.Image1.Canvas.Line(Te[1], Te[2], T2[1], T2[2]);

                //TOPLeftDOWN
  Cube[1] := 4;
  Cube[2] := 0;
  Cube[3] := 0;
  Cube[4] := 1;
  Te := To2D(RotateZ(RotateY(RotateX(GetNewCords(Cube),FiRotateX),FiRotateY),FiRotateZ));
  Cube[1] := 4;
  Cube[2] := 0;
  Cube[3] := 4;
  Cube[4] := 1;
  T2 := To2D(RotateZ(RotateY(RotateX(GetNewCords(Cube),FiRotateX),FiRotateY),FiRotateZ));
  Form1.Image1.Canvas.Line(Te[1], Te[2], T2[1], T2[2]);
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  Image1.Canvas.Pen.Color := clGreen;
  s := 0;
  FiRotateX:=0;
  FiRotateY:=0;
  FiRotateZ:=0;
  MotionX:=0;
  MotionY:=0;
  MotionZ:=0;
  World.X2 := -10;
  World.Y2 := 10;
  World.Z2 := 10;
  World.X1 := 10;
  World.Y1 := 0;
  World.Z1 := 0;
  Screen.X1 := 0;
  Screen.Y1 := 0;
  Screen.X2 := 500;
  Screen.Y2 := 300;

  UserCords[1]:=0;
  UserCords[2]:=0;
  UserCords[3]:=0;
  UserCords[4]:=1;

  Leftss();
  //ShowMessage(FloatToStr(Te[1])+' '+FloatToStr(Te[2])+' '+FloatToStr(T2[1])+' '+FloatToStr(T2[2]));

end;

procedure TForm1.FormKeyPress(Sender: TObject; var Key: char);
begin
  Clean();
  //showmessage(Key);
  case Key of
  'a':FiRotateX:=FiRotateX+0.05;
  's':FiRotateY:=FiRotateY+0.05;
  'd':FiRotateZ:=FiRotateZ+0.05;
  'z':FiRotateX:=FiRotateX-0.05;
  'x':FiRotateY:=FiRotateY-0.05;
  'c':FiRotateZ:=FiRotateZ-0.05;
  'y':UserCords[2]:=UserCords[2]+0.5;
  'h':UserCords[2]:=UserCords[2]-0.5;
  't':UserCords[1]:=UserCords[1]+0.5;
   'g':UserCords[1]:=UserCords[1]-0.5;
   'u':UserCords[3]:=UserCords[3]+0.5;
   'j':UserCords[3]:=UserCords[3]-0.5;
  end;

  Leftss();
end;

procedure TForm1.Image1Click(Sender: TObject);
begin
  {Clean();
  FiRotateX:=FiRotateX+0.1;
  FiRotateY:=FiRotateY+0.1;
  FiRotateZ:=FiRotateZ+0.1;
  Leftss();}
end;

procedure TForm1.Timer1Timer(Sender: TObject);
begin
  Image1.Canvas.Pen.Color := clGreen;
  s := s + 0.1;
  Cube[1] := 0;
  Cube[2] := 0;
  Cube[3] := 0;
  Cube[4] := 1;
  Te := To2D(RotateZ(Cube, s));
  Cube[1] := 0;
  Cube[2] := 0;
  Cube[3] := 4;
  Cube[4] := 1;
  T2 := To2D(RotateZ(Cube, s));
  Image1.Canvas.Line(Te[1], Te[2], T2[1], T2[2]);
  //ShowMessage(FloatToStr(Te[1])+' '+FloatToStr(Te[2])+' '+FloatToStr(T2[1])+' '+FloatToStr(T2[2]));  }
end;

end.