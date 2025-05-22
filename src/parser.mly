%token EOF
%token <int> INTEGER
%token PLUS DASH STAR SLASH D K MIN MAX
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
	| rolls=INTEGER D faces=INTEGER {
			if faces = 0 then raise (Invalid_argument "roll: zero-faced die");
			Dice.d rolls faces
	}
	| rolls=INTEGER D faces=INTEGER K keeps=INTEGER {
			if faces = 0 then raise (Invalid_argument "roll: zero-faced die");
			Dice.dk rolls faces keeps
	}
	| MAX f1=formula f2=formula { max f1 f2 }
	| MIN f1=formula f2=formula { min f1 f2 }
	| l=formula PLUS r=formula { l + r }
	| l=formula DASH r=formula { l - r }
	| l=formula STAR r=formula { l * r }
	| l=formula SLASH r=formula { l / r }

%%
