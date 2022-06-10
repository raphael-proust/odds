%token EOF
%token <int> INTEGER
%token PLUS DASH STAR SLASH D MIN MAX
%token LPAREN RPAREN

%left PLUS DASH
%left STAR SLASH
%nonassoc NEG
%left MAX MIN
%left D

%start<Dice.formula> entry

%%

entry:
	| t=formula EOF { t }

formula:
	| i=INTEGER { Dice.Constant i }
	| LPAREN t = formula RPAREN { t }
	| l=INTEGER D r=INTEGER {
			if r = 0 then raise (Invalid_argument "roll: zero-faced die");
			Dice.Dice (l, r)
	}
	| MAX f1=formula f2=formula { Dice.Best [f1; f2] }
	| MIN f1=formula f2=formula { Dice.Worst [f1; f2] }
	| l=formula PLUS r=formula { Dice.Plus (l, r) }
	| l=formula DASH r=formula { Dice.Minus (l, r) }
	| l=formula STAR r=formula { Dice.Mult (l, r) }
	| l=formula SLASH r=formula { Dice.Div (l, r) }
	| DASH t=formula %prec NEG { Dice.Neg t }

%%
