EXECUTABLE=asmv
BUILD=build
GENERATED=generated

CC=g++
CC_FLAGS=-w
LD_FLAGS=-lfl
INC=-I lib

all:		$(EXECUTABLE)

# File generation
$(GENERATED)/%.cpp: src/scanner.l src/parser.y
		$(shell mkdir $(GENERATED))
		flex -o $(GENERATED)/scanner.cpp src/scanner.l
		bison --defines=lib/parser.h -o $(GENERATED)/parser.cpp src/parser.y

$(EXECUTABLE):	$(GENERATED)/%.cpp src/asmv.cpp	
		$(shell mkdir $(BUILD))
		$(CC) $(CC_FLAGS) $(GENERATED)/*.cpp src/asmv.cpp $(INC) $(LD_FLAGS) -o $(EXECUTABLE)

clean:;		
		rm -rf $(GENERATED) $(BUILD) lib/parser.h $(EXECUTABLE)
