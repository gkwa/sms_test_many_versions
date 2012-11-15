name=deploy_sms

include VERSION.mk
version=$(majorv).$(minorv).$(microv).$(qualifierv)

installer=$(name)_v$(version).exe

changelog=$(installer)-changelog.txt

$(installer): $(name).nsi
	makensis \
		/V2 \
		/Doutfile=$(installer) \
		/Dname="$(name)" \
		/Dversion=$(version) \
		$<

upload: $(installer) $(changelog)
	-robocopy . //10.0.2.10/taylor.monacelli $^

.PHONY: upload

changelog: $(changelog)
$(changelog):
	git log --abbrev-commit --stat > $@
	unix2dos $@
.PHONY: $(changelog)

test: $(installer)
	cmd /c $(installer)
.PHONY: test

debug: $(installer) /debug
	cmd /c $(installer)
.PHONY: debug

un: uninstall
.PHONY: un
uninstall: Uninstall.bat
	cmd /c Uninstall.bat
.PHONY: uninstall

si: silent_install
.PHONY: si
silent_install: $(installer)
	cmd /c $(installer) /S
.PHONY: silent_install


Uninstall.bat: Uninstall.bat Makefile
	echo '@echo on' > $@
	echo 'cd "%PROGRAMFILES%\Streambox\${name}"' >> $@
	echo '.\Uninstall.exe' >> $@

test2: $(installer)
	-robocopy . //10.0.2.224/t $(installer)
.PHONY: test2


clean:
	rm -f \
		$(installer) \
		Uninstall.bat
.PHONY: clean
