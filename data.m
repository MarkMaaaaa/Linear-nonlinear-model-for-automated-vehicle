clear;
clc;
%% Hybrid Data
[~,~,data1_1]=xlsread('D:\project\data\test5.xlsx',1);
[~,~,data1_2]=xlsread('D:\project\data\test5.xlsx',2);
[~,~,data2_1]=xlsread('D:\project\data\test9.xlsx',1);
[~,~,data2_2]=xlsread('D:\project\data\test9.xlsx',2);

%%
%����ֵ�����뵥λ��m���ٶȵ�λ��m/s��
value_v=0.05;%�����ٶ���ֵ
Hz=10;%����Ƶ��
% data1_0=cell2mat(data1_0); 
P_T_0=cell2mat(data1_0(:,2));
Time_1_0=str2num(P_T_0(:,end-7:end));
% start_v_1_0=cell2mat(data1_0(:,5));
% start0=find(start_v_1_0>0.1);
P_T_1=cell2mat(data1_1(:,2));
Time_1_1=str2num(P_T_1(:,end-7:end));
start_v_1_1=cell2mat(data1_1(:,5));
start1=find(start_v_1_1>0.1);
t_end_1=Time_1_1(start1(end));

P_T_2=cell2mat(data1_2(:,2));
Time_1_2=str2num(P_T_2(:,end-7:end));
start_v_1_2=cell2mat(data1_2(:,5));
start2=find(start_v_1_2>0.1);
t_end_2=Time_1_2(start2(end));

t_end=min(t_end_1,t_end_2);
% t_1_0=Time_1_0(start0(1));
t_1_1=Time_1_1(start1(1));
n_1_2=find(Time_1_2==t_1_1);
% t_1_2=Time_1_2(start2(1));
% timeend_1=Time_1_1(start1(end));
N=409;
% T_start=
%��ʼֵ
%%
%����Ԥ����
lat_1_0=cell2mat(data1_0(:,4));lon_1_0=cell2mat(data1_0(:,3));v_1_0=cell2mat(data1_0(:,5));
lat_1_1=cell2mat(data1_1(:,4));lon_1_1=cell2mat(data1_1(:,3));v_1_1=cell2mat(data1_1(:,5));
lat_1_2=cell2mat(data1_2(:,4));lon_1_2=cell2mat(data1_2(:,3));v_1_2=cell2mat(data1_2(:,5));
mstruct=defaultm('mercator');%���������峤�ᣬ���ʣ�����ԭ��
mstruct.geoid=[ 6378137,0.0818191908426215];
mstruct.origin=[0,0,0];
mstruct=defaultm(mstruct);
[x_1_1,y_1_1] =projfwd(mstruct,lat_1_1,lon_1_1);
[x_1_2,y_1_2] =projfwd(mstruct,lat_1_2,lon_1_2);
min_v0=find(v_1_0>value_v);min_v1=find(v_1_1>value_v);
timestart_1=(min_v1(1)-1)/10+t_1_1;
% timeend_1=(min_v1(end)-1)/10+t_1_1;
% locstart_1_0=vpa((timestart_1-t_1_0)*10,3)+1;
% locend_1_0=vpa((timeend_1-t_1_0)*10,3)+1;
min_v2=find(v_1_2>value_v);
% timestart_2=min_v2(1);timeend_2=min_v2(end);
% timestart_1=vpa((min_v2(1)-1)/Hz+t_1_2);
% timeend_1=(min_v2(end)-1)/Hz+t_1_2;
% numstart_1_1=vpa((timestart_1-t_1_1)*10,3)+1;
% numend_1_1=vpa((timeend_1-t_1_1)*10,3)+1;
% numstart_1_2=vpa((timestart_1-t_1_2)*10,3)+1;
% numend_1_2=vpa((timeend_1-t_1_2)*10,3)+1;
% locstart_1_1=vpa((timestart_1-t_1_1)*Hz,3)+1;
% locend_1_1=vpa((timeend_1-t_1_1)*Hz,3)+1;
numstart_1_1=start1(1);
numend_1_1=find(Time_1_1==t_end);
numstart_1_2=n_1_2;
numend_1_2=n_1_2+numend_1_1-numstart_1_1;

L_1_1=x_1_1(numstart_1_1:numend_1_1);%����1��1��CAVλ��
V_1_1=v_1_1(numstart_1_1:numend_1_1);%����1��1��CAV�ٶ�
L_1_2=x_1_2(numstart_1_2:numend_1_2);%����1��2��CAVλ��
V_1_2=v_1_2(numstart_1_2:numend_1_2);%����1��2��CAV�ٶ�
difl_1=L_1_1-L_1_2;%������һ�����ڶ���
difv_1=V_1_1-V_1_2;%�ٶȲ��һ�����ڶ���

%%
%��������
%OV model
num=30;
Td=1.4;d_safe=1;
num_P=2;
b=cell(num_P,1,num);bint=cell(num_P,2,num);r=cell(1482,1,num);rint=cell(1482,2,num);stats=cell(1,4,num);
for i=1:num %delay����
    gap=difl_1(1:end-i)-V_1_2(1:end-i)*Td-d_safe;
    velocity=V_1_2(1:end-i);
    d_velocity=difv_1(1:end-i);
    a1=diff(V_1_2(i:end)).*Hz;%��һ��ʱ�̵ļ��ٶ�
    % a1=(V_1_2(i+Hz:end)-V_1_2(i:end-Hz)).*Hz;%��һ��ʱ�̵ļ��ٶ�
    
    X=[gap,d_velocity];
    [b1,bint1,r1,rint1,stats1] = regress(a1,X);
    b(:,:,i)=num2cell(b1);
    bint(:,:,i)=num2cell(bint1);
    % r(:,:,i)=num2cell(r1);
    % rint(:,:,i)=num2cell(rint1);
    stats(:,:,i)=num2cell(stats1);
end
x_time=1:size(a1);

%%
%OVM model
x_sim=L_1_2(1);
dt=0.1;
v_sim=V_1_2(1);
X_sim=[];
V_sim=[];
A_sim=[];
value_state=cell2mat(stats(1,1,:));
num_max=find(value_state==max(value_state));
T_delay=num_max;%����ʱ���ӳ�Ϊ1.7s
k_g=cell2mat(b(1,1,num_max));
% k_v=cell2mat(b(2,1,num_max));
k_dv=cell2mat(b(2,1,num_max));
% aa=k_g.*gap+k_v.*velocity+k_dv.*d_velocity;
aa=k_g.*gap+k_dv.*d_velocity;
vv=velocity+dt.*aa;
% plot(x_time,V_1_1(1:end-i),x_time,vv);
% figure;
% plot(x_time,V_1_1(1:end-i),x_time,V_1_2(1:end-i));
%���濪ʼ
% a_sim=k_g.*gap(1)+k_v.*velocity(1)+k_dv.*d_velocity(1);
a_sim=k_g.*gap(1)+k_dv.*d_velocity(1);
for ii=1:length(a1)-T_delay
    x_sim=x_sim+v_sim*dt+0.5*a_sim.*dt.^2;
    v_sim=v_sim+dt*a_sim;
    gap_sim=L_1_1(ii)-x_sim-v_sim*Td-d_safe;
    d_velocity_sim=V_1_1(ii)-v_sim;
    a_sim=k_g.*gap_sim+k_dv.*d_velocity_sim;
    X_sim=[X_sim,x_sim];
    V_sim=[V_sim,v_sim];
    A_sim=[A_sim,a_sim];
end
V_sim=[zeros(1,T_delay),V_sim];
X_sim=[ones(1,T_delay).*X_sim(1),X_sim];
% figure;
plot(x_time,V_1_1(1:end-i),x_time,V_1_2(1:end-i),x_time,V_sim);
xlabel('Time');
ylabel('Velocity (m/s)');
legend('Leading vehicle','Following vehicle(collected data)','Following vehicle(simulation)','best');
% path_1=['E:\My paper\ICTD2021\fig\1.fig'];
path_1=['E:\My paper\ICTD2021\fig\2.pdf'];
saveas(gcf,path_1);


X1=0.05:0.05:1.5;
K=[];
for i=1:30
    k=value_state(:,:,i);
    K=[K,k];
end
plot(X1,K);
xlabel('Time delay (s)');
ylabel('R square');
p=find(K==max(K));
grid on
text(X1(p),K(p),'o','FontSize',10,'color','r')
text(X1(p),K(p),['(',num2str(X1(p)),',',num2str(K(p)),')'],'FontSize',12,'Position',[0.7 0.9],'color','b');
path_2=['E:\My paper\ICTD2021\fig\2_j.pdf'];
saveas(gcf,path_2);


% figure;
% plot(x_time,L_1_1(1:end-i),x_time,L_1_2(1:end-i),x_time,X_sim);






%%
%{
scatter3(gap,velocity,a1,'filled');
hold on;  %�ڸո��Ǹ�ɢ��ͼ�Ͻ��Ż�
x1fit = linspace(min(gap),max(gap),100);   %����x1�����ݼ��
x2fit = linspace(min(velocity),max(velocity),100);    %����x2�����ݼ��
[X1FIT,X2FIT] = meshgrid(x1fit,x2fit);    %����һ����ά����ƽ�棬Ҳ����˵����X1FIT,X2FIT������
YFIT=b1(1)*X1FIT+b(2)*X2FIT;    %�����Ѿ���õĲ�������Ϻ���ʽ
mesh(X1FIT,X2FIT,YFIT)    %X1FIT��X2FIT�������������YFIT��������ϵĸ߶Ⱦ���
view(10,10)  %�ı�Ƕȹۿ��Ѵ��ڵ���άͼ����һ��10��ʾ��λ�ǣ��ڶ�����ʾ���ӽǡ�
             %��λ���൱���������еľ��ȣ����ӽ��൱���������е�γ��
xlabel('x1') %����X�������
ylabel('x2') %����y�������
zlabel('y')  %����z�������

%}


