AWK_EXE="/bin/awk -f"
MOPSE_EXE="mopse.awk"

SOURCES=$(wildcard src/*.awk)

CMD_CAT=cat
CMD_RM=rm

$(MOPSE_EXE): $(SOURCES)
	echo "#!$(AWK_EXE)" > $(MOPSE_EXE)
	for source in $?; do \
		$(CMD_CAT) $$source >> $(MOPSE_EXE); \
		echo "" >> $(MOPSE_EXE); \
	done
	chmod +x $(MOPSE_EXE)

.PHONY: all clean install

all: $(MOPSE_EXE)

clean:
	-$(CMD_RM) $(MOPSE_EXE)

install:
	echo "TODO"

portable:
