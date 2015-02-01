.PHONY: all build install clean deb repo release
PACKAGE=ssh-personal-environment

all: build

build:
	@echo No build required
	@echo Available targets: release install clean deb repo

release:
	git-dch --full --release --distribution stable --auto --git-author --commit

install:
	install -m 0755 sshrc.sh -D $(DESTDIR)/etc/ssh/sshrc
	install -m 0644 ssh_personal_environment.sh -D $(DESTDIR)/etc/profile.d/ssh_personal_environment.sh
	install -m 0755 -d $(DESTDIR)/usr/share/man/man1
	ronn --pipe <README.md | gzip -9 > $(DESTDIR)/usr/share/man/man1/update_ssh_personal_environment.1.gz

clean:
	rm -Rf debian/$(PACKAGE)* debian/files out/*

deb: clean
	debuild -i -us -uc -b --lintian-opts --profile debian
	mkdir -p out
	mv ../$(PACKAGE)*.{deb,build,changes} out/
	dpkg -I out/*.deb
	dpkg -c out/*.deb

repo:
	../putinrepo.sh out/*.deb

# vim: set ts=4 sw=4 tw=0 noet : 
