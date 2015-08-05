build:
	jekyll build
serve:
	jekyll serve --watch

TARGET = devlog
ARCHIVE = devlog.tar.gz
USR_HOST = web@wombatant.net
deploy: build
	rm -rf $(TARGET) $(ARCHIVE)
	mv _site $(TARGET)
	tar czf $(ARCHIVE) $(TARGET)
	scp $(ARCHIVE) $(USR_HOST):
	ssh $(USR_HOST) 'tar xf $(ARCHIVE) && rm -f $(ARCHIVE)'
	rm -rf $(TARGET) $(ARCHIVE)
