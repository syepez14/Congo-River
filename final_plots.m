clear all
load data.mat

%SST.X columna 1, datos de SSC y columna 2 datos de backscatter. 
%X.pre columna 1, datos de SSC estandarizados y columna 2 datos de
%backscatter estandarizados. Estandarización = (data-mean)/standard deviation

%% Parte 1: graficamos los datos crudo.
cu=unique(SST.Label.Transect);
vector=1:size(Xpre,1);
colors={'green','blue','red','yellow','cyan'};
cuu={'Brazza-Kin    December 27th, 2023','Brazza-Kin    May 4th, 2023','VN-MBAMU   March 29th, 2023','QP-MBAMU   March 23rd, 2023','YORO             October 19th, 2022'};
unidades={'SSC Standardized (mg/L)',{'ABS Standardized (dB)'}};
u=[0 1];
figure(1)
for j=1:2
    subplot(2,1,j)
    for i=1:5
        hold on
        these=strcmp(SST.Label.Transect,cu{i});
        bar(vector(these),Xpre(these,j),'FaceColor',colors{i});
        ylabel(unidades{j},'FontSize',14,'FontWeigh','bold')
        hold off
    end
    xlabel('Data Number','FontSize',14,'FontWeigh','bold')
    grid on
    ax = gca;  % Obtener el objeto de los ejes actuales
ax.LineWidth = 1.2;
end
legend(cuu,'FontSize',12,'FontWeight','bold')

%subplot(2,2,[2 4])
scatter(SST.X(:,2),SST.X(:,1),'filled','k'); 
xlabel('Acoustic Backscatter Signal (dB)','FontSize',16,'FontWeight','bold');
ylabel('SSC (mg/L)','FontSize',16,'FontWeight','bold')
title(['Data Number=' num2str(length(SST.X(:,1)))],'FontSize',16)
ylim([0 50])
xlim([70 100])
ax = gca;  % Obtener el objeto de los ejes actuales
ax.LineWidth = 1.2;
%xlabel('Acoustic Backscatter signal')
%ylabel('Suspended Sediment Concentration [mg/L]')

clearvars -except Xpre SST

var=Xpre>0; %valores de datos estandarizados positivos 1 y negativos 0 
SST2=var(:,1);
BACK=var(:,2);
x=[];
%Las variables SST22 y BACK seran columnas de datos logicos donde 1 seran
%positivos y 0 seran negativos
for i=1:length(SST2)
    if SST2(i)==BACK(i) 
        x=[x;i]; %%% posiciones donde los datos estandarizados tienen el mismo signo positivo o negativo 
    end
end
clearvars SST2 BACK var i
%creamos una nueva estructura consevando unicamente los valores en la posicion x
X=SST.X(x,:);  % valores donde se cumple la condicion que escogimos
anomalia=Xpre(x,:);
T=SST.Label.Transect(x,:); % nombre transectos, quitamos las posiciones 
cu=unique(T);
vector=1:size(X,1);
colors={'green','blue','red','yellow','cyan'};
unidades={'Suspended Sediment concentration [mg/L]',{'Backscatter'}};
u=[0 1];
% figure(2)
% for j=1:2
%     subplot(2,2,j+u(j))
%     for i=1:5
%         hold on
%         these=strcmp(T,cu{i});
%         bar(vector(these),anomalia(these,j),'FaceColor',colors{i});
%         ylabel(unidades{j})
%         hold off
%     end
%     title('Anomalias')
% end
% legend(cu)
% 
% 
% 
% subplot(2,2,[2 4])
% scatter(X(:,2),X(:,1),'filled'); xlabel('Backscatter');ylabel('SST (mg/L)')
% text(72,40,['r =',num2str(sprintf('%.2f',corr(X(:,2),X(:,1))))],'FontSize',18)
% text(72,35,['r^2 =' num2str(sprintf('%.2f',corr(X(:,2),X(:,1))^2))],'FontSize',18)
% title(['scatterplot de todos los datos sin filtrar ' 'N= ' num2str(length(X(:,1)))],'FontSize',18)
% ylim([0 50])
% xlim([70 100])

%% Parte 3: filtramos nuevamente los datos
% writematrix(X,'goodpoint.xlsx')

var=anomalia(:,1)-anomalia(:,2); % solo dejamos las anomalias del mismo signo que esten a cierta magnitud de diferencia igual a in
in=abs(var) < 0.85;
X2=X(in,:); % variables filtradas (X) filtradas nuevame, mg/L
T2=T(in,:); % transectas de variables doblemente filtradas
anomalia2=anomalia(in,:);
clearvars -except SST T2 X2 anomalia2


cu=unique(T2);
vector=1:size(X2,1);
colors={'green','blue','red','yellow','cyan'};
unidades={'SSC Standardized',{'ABS Standardized'}};
u=[0 1];
cuu={'Brazza-Kin    27/12/2023','Brazza-Kin    04/05/2023','MALUKO      29/03/2023','QP-MBAMU 23/03/2023','YORO          19/10/2022'};
figure(3)
for j=1:2
    subplot(2,2,j+u(j))
    for i=1:5
        hold on
        these=strcmp(T2,cu{i});
        bar(vector(these),anomalia2(these,j),'FaceColor',colors{i});
        ylabel(unidades{j},'FontSize',15,'FontWeight','bold')
        hold off
    end
    xlabel('Data Number','FontSize',15,'FontWeight','bold')
    %set(gca,'FontSize',10,'FontWeigh','bold')

end
legend(cuu,'FontSize',9)

x=1:100;
modelo=0.0149*exp(0.0836*x);

correlacion=0.83; % correlacion de un ajuste exponencial hecha en excel 
coeficiente_correlacion=0.69; % Coeficiente de correlacion de un ajuste exponencial hecho en excel 

subplot(2,2,[2 4])
scatter(X2(:,2),X2(:,1),'filled','k'); 
xlabel('Acustic Backscatter Signal (dB)','FontSize',15,'FontWeight','bold');
ylabel('SSC (mg/L)','FontSize',15,'FontWeight','bold')
text(71,48,['r =' num2str(correlacion)],'FontSize',15,'FontWeight','bold')
text(71,44,['R^2=' num2str(coeficiente_correlacion)],'FontSize',15,'FontWeight','bold')
text(82,6,['SSC=0.0149*exp(0.0836*ABS)'],'FontSize',15)
text(82,5,['N=' num2str(length(X2(:,1)))],'FontSize',15)
%title(['Scatter plot ' 'N= ' num2str(length(X2(:,1)))],'FontSize',17)
ylim([0 50])
xlim([70 100])
%set(gca,'FontSize',12,'FontWeigh','bold')
hold on
plot(modelo,'r','LineWidth',1.5)
ax = gca;  % Obtener el objeto de los ejes actuales
ax.LineWidth = 1.2;  % Establecer el grosor deseado (por ejemplo, 2)
hold off
% writematrix(X2,'goodpoint2.xlsx')

 
[coef_corr, p] = corr(X2(:,2),X2(:,1));
