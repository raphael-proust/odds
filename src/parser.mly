
%{

open Types

%}

%token EOF
%token <int> INTEGER
%token PLUS DASH STAR SLASH D
%token LPAREN RPAREN

%left PLUS DASH
%left STAR SLASH
%nonassoc NEG
%left D

%start<Types.t> entry

%%

entry:
	| t=formula EOF { t }

formula:
	| k=INTEGER { K k }
	| LPAREN t = formula RPAREN { t }
	| l=formula D r=formula { Binop(l, Dice, r) }
	| l=formula PLUS r=formula { Binop(l, Add, r) }
	| l=formula DASH r=formula { Binop(l, Sub, r) }
	| l=formula STAR r=formula { Binop(l, Mul, r) }
	| l=formula SLASH r=formula { Binop(l, Div, r) }
	| DASH t=formula %prec NEG { Unop(Neg, t) }

%%