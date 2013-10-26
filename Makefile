201101101_project: project_phase1.l project_phase1.y
		   bison -d project_phase1.y
		   flex project_phase1.l
		   gcc -o $@ project_phase1.tab.c lex.yy.c -lfl
