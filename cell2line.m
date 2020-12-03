function line=cell2line(datacell)

line=num2str(datacell{1});
for i=2:length(datacell)
	line=[line ' ' num2str(datacell{i})];
end
