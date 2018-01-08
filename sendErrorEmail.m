function sendErrorEmail(ME)

path = 'C:\Users\MacLabInVivo\Documents\Mouse SE Analysis Tool v 2_1\';
cd(path);
fID = fopen('ErrorList.txt', 'a');
time = clock;
fprintf(fID, '%d %d %d %d %d %d \n', time);
fprintf(fID, '%s \n', ME.identifier);
fprintf(fID, '%s \n', ME.message);
fclose(fID);
setpref('Internet','SMTP_Server','smtp.gmail.com');
setpref('Internet','E_mail','neuroautomationsolutionsllc@gmail.com');
setpref('Internet','SMTP_Username','neuroautomationsolutionsllc');
setpref('Internet','SMTP_Password','Standard01');
props = java.lang.System.getProperties;
props.setProperty('mail.smtp.auth','true');
props.setProperty('mail.smtp.socketFactory.class', 'javax.net.ssl.SSLSocketFactory');
props.setProperty('mail.smtp.socketFactory.port','465');
sendmail('ceh50@duke.edu', 'Error Report', 'Error Report', 'ErrorList.txt') ;