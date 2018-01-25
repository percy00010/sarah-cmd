unit CmdParse;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, fpexprpars, Dialogs, Forms, Func;

type
  TCmdParse = Class
  public
    Expression: string;
    function NewValue( Variable:string; Value: Double ): Double;
    procedure AddVariable( Variable: string; Value: Double );
    procedure AddString( Variable: string; Value: string );
    function Evaluate(): Double;
    constructor Create();
    destructor Destroy(); override;
  private
    FParser: TFPExpressionParser;
    identifier: array of TFPExprIdentifierDef;
    procedure AddFunctions();
  end;

implementation

constructor TCmdParse.create;
begin
   FParser:= TFPExpressionParser.Create( nil );
   FParser.Builtins := [ bcMath ];
   AddFunctions();
end;

destructor TCmdParse.Destroy;
begin
  FParser.Destroy;
end;

function TCmdParse.NewValue( Variable: string; Value: Double ): Double;
begin
  FParser.IdentifierByName(Variable).AsFloat:= Value;
end;

function TCmdParse.Evaluate(): Double;
begin
  FParser.Expression:= Expression;
  Result:= ArgToFloat(FParser.Evaluate);
end;

procedure TCmdParse.AddFunctions();
begin
  with FParser.Identifiers do begin
     AddFunction('plot', 'F', 'SFFF', @ExprPlot);
  end
end;

procedure TCmdParse.AddVariable( Variable: string; Value: Double );
var Len: Integer;
begin
  Len:= length( identifier ) + 1;
  SetLength( identifier, Len ) ;
  identifier[ Len - 1 ]:= FParser.Identifiers.AddFloatVariable( Variable, Value);
end;

procedure TCmdParse.AddString( Variable: string; Value: string );
var Len: Integer;
begin
  Len:= length( identifier ) + 1;
  SetLength( identifier, Len ) ;

  identifier[ Len - 1 ]:= FParser.Identifiers.AddStringVariable( Variable, Value);
end;

end.

