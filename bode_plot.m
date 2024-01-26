clear;
clc;

sys1= tf([0.294, 0.074],[1, 0.479, 0.088]);
sys2= tf([],[]);
sys3= tf([],[]);
sys4= tf([],[]);


[mag, phase, wout,sdmag, sdphase] = bode(sys1)




