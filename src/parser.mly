%{

open Odds
open Odds.Integer

%}

%token EOF
%token <int> INTEGER
%token PLUS DASH STAR SLASH D
%token LPAREN RPAREN

%left PLUS DASH
%left STAR SLASH
%nonassoc NEG
%left D

%start<Odds.t> entry

%%

entry:
	| t=formula EOF { t }

formula:
	| i=INTEGER { !i }
	| LPAREN t = formula RPAREN { t }
	| l=formula D r=formula { dice l r }
	| l=formula PLUS r=formula { l + r }
	| l=formula DASH r=formula { l - r }
	| l=formula STAR r=formula { l * r }
	| l=formula SLASH r=formula { l / r }
	| DASH t=formula %prec NEG { ~- t }

%%
