function timeStr = getInfusionTime(dose, weight, conc, rate)
time = dose*(weight/1000)*(1/conc)*(1/rate);
sec = round(60*mod(time, 1));
min = time - mod(time,1);
timeStr = strcat(num2str(min), ':', num2str(sec));
