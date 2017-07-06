
%{

%}

%token EOF
%token<int> INTEGER
%token DICE
%token PLUS

%start<Types.t> formula

%%

formula:
	| atoms = separated_nonempty_list(PLUS, atom) EOF { atoms }

atom:
	| n=INTEGER DICE s=INTEGER { Types.D (n, s) }
	| k=INTEGER { Types.K k }

%%
