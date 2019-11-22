
main:
	ocamlbuild ftest.byte

format:
	ocp-indent --inplace src/*

clean:
	rm -rf _build/
	rm ftest.byte
