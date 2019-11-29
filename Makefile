
main:
	ocamlbuild ftest.byte

money:
	ocamlbuild mtest.byte

format:
	ocp-indent --inplace src/*

clean:
	rm -rf _build/
	rm -rf _temp/
	rm ftest.byte
	rm mtest.byte
