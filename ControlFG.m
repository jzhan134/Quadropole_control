function ControlFG(opt_device,freq1, freq2, volt1, volt2)
if opt_device == 1
    fprintf(inst,'source:function sin');
    fprintf(inst,['source:frequency ', num2str(freq1)]);
else
    fprintf(inst,'source1:function sin');
    fprintf(inst,'source2:function sin');
    fprintf(inst,['source1:frequency ', num2str(freq1)]);
    fprintf(inst,['source2:frequency ', num2str(freq2)]);
end

if opt_device == 1
    fprintf(inst,['source:voltage ',num2str(volt1)]);
    fprintf(inst,'outp on');
else
    fprintf(inst,['source1:voltage ',num2str(volt1)]);
    fprintf(inst,['source2:voltage ',num2str(volt2)]);
    fprintf(inst,'outp1 on');
    fprintf(inst,'outp2 on');
end
end