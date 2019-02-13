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

  { TMainScene }

  TMainScene = class(TForm)
    CanvasScene: TImage;
    Timer: TTimer;
    procedure FormCreate(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: char);
    procedure TimerTimer(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end;

function RotateX(Test: Matrix3D; Fi: real): Matrix3D;
function RotateY(Test: Matrix3D; Fi: real): Matrix3D;
function RotateZ(Test: Matrix3D; Fi: real): Matrix3D;
function To2D(Test: Matrix3D): Matrix2D;
function GetNewCords(Cords: Matrix3D): Matrix3D;
procedure Clean();
procedure Print();
procedure PrintEdge(F1, S1, T1: real; F2, S2, T2: real);
procedure CleanEdge(F1, S1, T1: real; F2, S2, T2: real);

var
  MainScene: TMainScene;
  World: World3D;
  Screen: Scene;
  s: real;
  FiRotateX, FiRotateZ, FiRotateY: real;
  MotionX, MotionY, MotionZ: real;
  UserCords: Matrix3D;

implementation

{$R *.lfm}

{ TMainScene }

procedure CleanEdge(F1, S1, T1: real; F2, S2, T2: real);
var
  Edge: Matrix3D;
  Vertex1, Vertex2: Matrix2D;
begin
  MainScene.CanvasScene.Canvas.Pen.Color := clBlack;
  Edge[1] := F1;
  Edge[2] := S1;
  Edge[3] := T1;
  Edge[4] := 1;
  Vertex1 := To2D(RotateZ(RotateY(RotateX(GetNewCords(Edge), FiRotateX), FiRotateY),
    FiRotateZ));
  Edge[1] := F2;
  Edge[2] := S2;
  Edge[3] := T2;
  Edge[4] := 1;
  Vertex2 := To2D(RotateZ(RotateY(RotateX(GetNewCords(Edge), FiRotateX), FiRotateY),
    FiRotateZ));
  MainScene.CanvasScene.Canvas.Line(Vertex1[1], Vertex1[2], Vertex2[1], Vertex2[2]);
end;

procedure PrintEdge(F1, S1, T1: real; F2, S2, T2: real);
var
  Edge: Matrix3D;
  Vertex1, Vertex2: Matrix2D;
begin
  MainScene.CanvasScene.Canvas.Pen.Color := clGreen;
  Edge[1] := F1;
  Edge[2] := S1;
  Edge[3] := T1;
  Edge[4] := 1;
  Vertex1 := To2D(RotateZ(RotateY(RotateX(GetNewCords(Edge), FiRotateX), FiRotateY),
    FiRotateZ));
  Edge[1] := F2;
  Edge[2] := S2;
  Edge[3] := T2;
  Edge[4] := 1;
  Vertex2 := To2D(RotateZ(RotateY(RotateX(GetNewCords(Edge), FiRotateX), FiRotateY),
    FiRotateZ));
  MainScene.CanvasScene.Canvas.Line(Vertex1[1], Vertex1[2], Vertex2[1], Vertex2[2]);
end;

function GetNewCords(Cords: Matrix3D): Matrix3D;
begin
  GetNewCords[1] := 1 * Cords[1] + UserCords[1] * Cords[4];
  GetNewCords[2] := 1 * Cords[2] + UserCords[2] * Cords[4];
  GetNewCords[3] := 1 * Cords[3] + UserCords[3] * Cords[4];
  GetNewCords[4] := UserCords[4] * Cords[4];
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
  To2D[1] := Trunc(((Screen.X2 - Screen.X1) / (World.X2 - World.X1)) *
    Test[1] + (Screen.X1 - (World.X1 * (Screen.X2 - Screen.X1) /
    (World.X2 - World.X1))));
  To2D[2] := Trunc((-Screen.Y2 - Screen.Y1) / (World.Y2 - World.Y1) *
    Test[2] + (Screen.Y2 - (World.Y1 * (Screen.Y2 - Screen.Y1) /
    (World.Y2 - World.Y1))));
end;

procedure Clean();
begin
  //DOWN
  CleanEdge(2 + MotionX, -2, -2, -2 + MotionX, -2, -2);


  //Left
  CleanEdge(-2 + MotionX, -2 + MotionY, -2, -2 + MotionX, -2 + MotionY, 2);

  //Mid
  CleanEdge(-2 + MotionX, -2 + MotionY, -2, -2 + MotionX, 2 + MotionY, -2);

  //TopDOWN
  CleanEdge(-2 + MotionX, 2 + MotionY, -2, 2 + MotionX, 2 + MotionY, -2);

  //TOPLeft
  CleanEdge(-2 + MotionX, 2 + MotionY, -2, -2 + MotionX, 2 + MotionY, 2);



  //TOPLeftDOWN
  CleanEdge(-2 + MotionX, 2 + MotionY, 2, -2 + MotionX, -2 + MotionY, 2);

  //TOPUPD
  CleanEdge(-2 + MotionX, 2 + MotionY, 2, 2 + MotionX, 2 + MotionY, 2);

  //TOPLeftDOWN  true 22
  CleanEdge(2 + MotionX, -2 + MotionY, -2, 2 + MotionX, 2 + MotionY, -2);

  //TOPLeftDOWN
  CleanEdge(2 + MotionX, 2 + MotionY, 2, 2 + MotionX, -2 + MotionY, 2);

  //TOPLeftDOWN
  CleanEdge(2 + MotionX, -2 + MotionY, 2, 2 + MotionX, -2 + MotionY, -2);

  //TOPLeftDOWN
  CleanEdge(2 + MotionX, -2 + MotionY, 2, -2 + MotionX, -2 + MotionY, 2);

  //TOPLeftDOWN true
  CleanEdge(2 + MotionX, 2 + MotionY, -2, 2 + MotionX, 2 + MotionY, 2);

  //TOPLeftDOWN
  CleanEdge(2 + MotionX, -2 + MotionY, -2, 2 + MotionX, -2 + MotionY, 2);
end;

procedure Print();
begin
  //DOWN
  PrintEdge(2 + MotionX, -2, -2, -2 + MotionX, -2, -2);


  //Left
  PrintEdge(-2 + MotionX, -2 + MotionY, -2, -2 + MotionX, -2 + MotionY, 2);

  //Mid
  PrintEdge(-2 + MotionX, -2 + MotionY, -2, -2 + MotionX, 2 + MotionY, -2);

  //TopDOWN
  PrintEdge(-2 + MotionX, 2 + MotionY, -2, 2 + MotionX, 2 + MotionY, -2);

  //TOPLeft
  PrintEdge(-2 + MotionX, 2 + MotionY, -2, -2 + MotionX, 2 + MotionY, 2);

  //TOPLeftDOWN
  PrintEdge(-2 + MotionX, 2 + MotionY, 2, -2 + MotionX, -2 + MotionY, 2);

  //TOPUPD
  PrintEdge(-2 + MotionX, 2 + MotionY, 2, 2 + MotionX, 2 + MotionY, 2);

  //TOPLeftDOWN  true 22
  PrintEdge(2 + MotionX, -2 + MotionY, -2, 2 + MotionX, 2 + MotionY, -2);

  //TOPLeftDOWN
  PrintEdge(2 + MotionX, 2 + MotionY, 2, 2 + MotionX, -2 + MotionY, 2);

  //TOPLeftDOWN
  PrintEdge(2 + MotionX, -2 + MotionY, 2, 2 + MotionX, -2 + MotionY, -2);

  //TOPLeftDOWN
  PrintEdge(2 + MotionX, -2 + MotionY, 2, -2 + MotionX, -2 + MotionY, 2);

  //TOPLeftDOWN true
  PrintEdge(2 + MotionX, 2 + MotionY, -2, 2 + MotionX, 2 + MotionY, 2);

  //TOPLeftDOWN
  PrintEdge(2 + MotionX, -2 + MotionY, -2, 2 + MotionX, -2 + MotionY, 2);
end;

procedure TMainScene.FormCreate(Sender: TObject);
begin
  CanvasScene.Canvas.Pen.Color := clGreen;
  s := 0;
  FiRotateX := 0;
  FiRotateY := 0;
  FiRotateZ := 0;
  MotionX := 0;
  MotionY := 0;
  MotionZ := 0;
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
  UserCords[1] := 0;
  UserCords[2] := 0;
  UserCords[3] := 0;
  UserCords[4] := 1;
  Print();
end;


procedure TMainScene.FormKeyPress(Sender: TObject; var Key: char);
begin
  Clean();
  case LowerCase(Key) of
    'a': FiRotateX := FiRotateX + 0.05;
    's': FiRotateY := FiRotateY + 0.05;
    'd': FiRotateZ := FiRotateZ + 0.05;
    'z': FiRotateX := FiRotateX - 0.05;
    'x': FiRotateY := FiRotateY - 0.05;
    'c': FiRotateZ := FiRotateZ - 0.05;
    'y':
    begin
      World.Y1 := World.Y1 + 0.5;
      World.Y2 := World.Y2 + 0.5;
      UserCords[2] := UserCords[2] + 0.5;
    end;
    'h':
    begin
      World.Y2 := World.Y2 - 0.5;
      World.Y1 := World.Y1 - 0.5;
      UserCords[2] := UserCords[2] - 0.5;
    end;
    't':
    begin
      UserCords[1] := UserCords[1] + 0.5;
      World.X2 := World.X2 + 0.5;
      World.X1 := World.X1 + 0.5;
    end;
    'g':
    begin
      UserCords[1] := UserCords[1] - 0.5;
      World.X2 := World.X2 - 0.5;
      World.X1 := World.X1 - 0.5;
    end;
    'u':
    begin
      World.Z1 := World.Z1 + 0.5;
      World.Z2 := World.Z2 + 0.5;
      UserCords[3] := UserCords[3] + 0.5;
    end;
    'j':
    begin
      World.Z1 := World.Z1 - 0.5;
      World.Z2 := World.Z2 - 0.5;
      UserCords[3] := UserCords[3] - 0.5;
    end;
    'm': if (Timer.Enabled) then
        Timer.Enabled := False
      else
        Timer.Enabled := True;
  end;
  Print();
end;

procedure TMainScene.TimerTimer(Sender: TObject);
begin
  Clean();
  FiRotateX := FiRotateX + 0.05;
  FiRotateY := FiRotateY + 0.05;
  FiRotateZ := FiRotateZ + 0.05;
  Print();
end;

end.
