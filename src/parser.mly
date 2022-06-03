%token EOF
%token <int> INTEGER
%token PLUS DASH STAR SLASH D MIN MAX
%token LPAREN RPAREN

%left PLUS DASH
%left STAR SLASH
%nonassoc NEG
%left MAX MIN
%left D

%start<int> entry

%%

entry:
	| t=formula EOF { t }

formula:
	| i=INTEGER { i }
	| LPAREN t = formula RPAREN { t }
	| l=formula D r=formula {
			if r = 0 then raise (Invalid_argument "roll: zero-faced die");
			DiceEffects.roll_multiple l r
	}
	| MAX f1=formula f2=formula { max f1 f2 }
	| MIN f1=formula f2=formula { min f1 f2 }
	| l=formula PLUS r=formula { l + r }
	| l=formula DASH r=formula { l - r }
	| l=formula STAR r=formula { l * r }
	| l=formula SLASH r=formula { l / r }
	| DASH t=formula %prec NEG { ~- t }

%%
