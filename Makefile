AWK_EXE="/bin/awk -f"
MOPSE_EXE="mopse.awk"

CMD_CAT=cat
CMD_RM=rm

$(MOPSE_EXE): $(wildcard src/*.awk)
	echo "#!$(AWK_EXE)" > $(MOPSE_EXE)
	for source in $?; do                     \
		$(CMD_CAT) $$source >> $(MOPSE_EXE); \
		echo "" >> $(MOPSE_EXE);             \
	done

.PHONY: all clean install

all: $(MOPSE_EXE)

clean:
	-$(CMD_RM) $(MOPSE_EXE)

install:
	echo "TODO"
