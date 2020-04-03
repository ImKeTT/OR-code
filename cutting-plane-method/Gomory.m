close all;
clear all;

format rat;%?????????
A=[-1,3,1,0;
    7,1,0,1];
b=[6,35]';
c=[7,9,0,0];
n=4;
m=2;
% A=[1,1,1,0,0;
%     -1,1,0,1,0;
%     6,2,0,0,1];
% b=[5,0,21]';
% c=[2,1,0,0,0];
% n=5;
% m=3;
[xstar,fxstar,iter] = Gomory(A,b,c,n,m)

function [xstar,fxstar,iter] = Gomory(A,b,c,n,m)
    %????????
    init_eye_pos=nchoosek(1:1:n,m);
    [row,col]=size(init_eye_pos);
    for i = 1:row
        tmp_init_eye=init_eye_pos(i,:);
        init_eye=A(:,tmp_init_eye);
        flag=is_ones(init_eye);
        if flag==1
            fin_ji_x=tmp_init_eye;
            break;
        end
    end
    
    while 1
        %????b???0?????????????????
        if min(b)>=0
            disp("??????");
            %fin_ji_x?fin_A?fin_b ??????????????A???b??
            %????ji_x????????????????
            [x_opt,fx_opt,iter,fin_ji_x,fin_A,fin_b]=Simplex_eye(A,b,c,n,m,fin_ji_x)
        else
            disp("????????");
            [x_opt,fx_opt,iter,fin_ji_x,fin_A,fin_b]=DSimplex_eye(A,b,c,n,m,fin_ji_x)
        end
        
        %??????????????1??????????????????????????
        tmp_ji_x=zeros(1,m+1);%????m?????????m+1???n+1
        for ji_pos=1:m
            tmp_ji_x(1,ji_pos)=fin_ji_x(1,ji_pos);
        end
        tmp_ji_x(1,m+1)=n+1;
        fin_ji_x=tmp_ji_x;
        
        %??????????????
        flag_zhengshu=1;%flag_zhengshu????1??????????,flag_zhengshu??0
        for pos_x = 1:m
            if abs(round(x_opt(pos_x,1))-x_opt(pos_x,1))>=1e-3%??????
                flag_zhengshu=0;
                break;
            end
        end
        if flag_zhengshu==1%?????????????????
            xstar=x_opt;
            fxstar=fx_opt;
            break;
        end
        
        %??????????
        choose_row_value=0;%???????????0
        for pos_row = 1:m%????b????????????????
            tmp=get_max_chazhi(fin_b(pos_row,1));
            if tmp>choose_row_value
                choose_row_value=tmp;
                choose_row_pos = pos_row;%???????????
            end
        end
        
        n=n+1;
        m=m+1;
        iter=iter+1;
        
        %?????????????????????(?0)??(m,n)=1
        tmp_A5=zeros(m,n);
        tmp_b5=zeros(m,1);
        tmp_c5=zeros(1,n);
        for i5=1:m-1
            for j5=1:n-1
                tmp_A5(i5,j5)=fin_A(i5,j5);
            end
            tmp_b5(i5,1)=fin_b(i5,1);
        end
        tmp_A5(m,n)=1;
        for i5=1:n-1
            tmp_c5(1,i5)=c(i5);
        end
        
        %??????
        for add_pos = 1:n-1
            flag_not_ji=1;
            for ji=1:m-1
                if add_pos==fin_ji_x(ji)
                    flag_not_ji=0;
                    break;
                end
            end
            if flag_not_ji==1
                tmp_A5(m,add_pos)=-get_max_chazhi(fin_A(choose_row_pos ,add_pos));
            end
        end
        tmp_b5(m,1)=-choose_row_value;
        A=tmp_A5
        b=tmp_b5
        c=tmp_c5
        n
        m
        
    end
end

%??????????
function [max_chazhi] = get_max_chazhi(x)%????????
    if x>=0
        max_chazhi=x-floor(x);
    else
        max_chazhi=x-floor(x);
    end
end

function [x_opt,fx_opt,iter,fin_ji_x,fin_A,fin_b]=Simplex_eye(A,b,c,n,m,ji_x)
    iter=0;
    %??????
    chi_da=(zeros(m))';
    sigma=zeros(1,n)';
    CB=(zeros(1,m))';
    for cb_pos=1:m
        for c_pos=1:n
            if ji_x(cb_pos)==c_pos
                CB(cb_pos,1)=c(c_pos);
            end
        end
    end
    tmp_A=A;
    flag=1;
    while flag
        iter=iter+1;
        %??sigma,?????
        for pos_c = 1:n
            sigma(pos_c,1)=c(pos_c);
            for pos_tmp = 1:m
                sigma(pos_c,1)=sigma(pos_c,1)-CB(pos_tmp,1)*tmp_A(pos_tmp,pos_c);
            end
        end
        max_sigma=-1;
        for pos_sigma = 1:n
            if sigma(pos_sigma,1)>max_sigma
                max_sigma_pos=pos_sigma;
                max_sigma=sigma(pos_sigma,1);
            end
        end
        if max_sigma<=0%?????????
            x_opt=(zeros(1,n))';
            x_opt(ji_x,1)=b(:,1);
            fx_opt=0;
            for pos_x1 = 1:n
                fx_opt=fx_opt+c(pos_x1)*x_opt(pos_x1,1);
            end
            fin_A=tmp_A;
            fin_b=b;
            fin_ji_x=ji_x;
            flag=0;
        else
            %??chi_da??????
            for chi_da_pos=1:m
                chi_da(chi_da_pos,1)=b(chi_da_pos,1)/tmp_A(chi_da_pos,max_sigma_pos);
            end
            min_chi_da=-1;
            for chi_da_pos=1:m
                if chi_da(chi_da_pos,1)>0 && tmp_A(chi_da_pos,max_sigma_pos)>0%??min(chi_da)>0??????????>0(????)
                    if min_chi_da==-1 || chi_da(chi_da_pos,1)<min_chi_da%?????chi_da?????
                        min_chi_da=chi_da(chi_da_pos,1);
                        min_chi_da_pos=ji_x(chi_da_pos);
                    end
                end
            end
            if min_chi_da==-1
                disp("???");%????????
                flag=0;
            else
                out_x_pos=min_chi_da_pos%???
                in_x_pos=max_sigma_pos%???
                for in_out = 1:m
                    if ji_x(in_out)==out_x_pos
                        ji_x(in_out)=in_x_pos;
                        CB(in_out,1)=c(in_x_pos);
                        break;
                    end
                end
                %????????????????????????????????????????????????
                %???????????1
                tmp_beishu=tmp_A(in_out,ji_x(in_out));
                for change_1 =1:n
                    tmp_A(in_out,change_1)=tmp_A(in_out,change_1)/tmp_beishu;
                end
                b(in_out,1)=b(in_out,1)/tmp_beishu;%???b???????
                %?????????
                for change_pos =1:m
                      if change_pos~=in_out%???????
                          beishu=tmp_A(change_pos,in_x_pos);
                          for tt=1:n%?????????
                              tmp_A(change_pos,tt)=tmp_A(change_pos,tt)-beishu*tmp_A(in_out,tt);
                          end
                          b(change_pos,1)=b(change_pos,1)-beishu*b(in_out,1);%????b??
                      end
                end
            end
        end
    end
end

%x_opt?????fx_opt???????iter?????
function [x_opt,fx_opt,iter,fin_ji_x,fin_A,fin_b]=DSimplex_eye(A,b,c,n,m,ji_x)
    iter=0;
    %??????
    sigma=zeros(1,n);
    CB=(zeros(1,m))';
    for cb_pos=1:m-1
        for c_pos=1:n-1
            if ji_x(cb_pos)==c_pos
                CB(cb_pos,1)=c(c_pos);
                break;
            end
        end
    end
    tmp_A=A;
    flag=1;
    while flag
        %??b??????
        min_b=0;
        for i = 1:m
            if b(i)<min_b
                min_b=b(i);
                min_b_pos=ji_x(i);
                min_b_pos_tmp=i;
            end
        end
        
        if min_b>=0%?????????
            x_opt=(zeros(1,n))';
            x_opt(ji_x,1)=b(:,1);
            fx_opt=0;
            for pos_x2 = 1:n
                fx_opt=fx_opt+c(pos_x2)*x_opt(pos_x2,1);
            end
            fin_A=tmp_A;
            fin_b=b;
            fin_ji_x=ji_x;
            flag=0;
            break;
        else
            %??sigma,?????
            for pos_c = 1:n
                sigma(1,pos_c)=c(1,pos_c);
                for pos_tmp = 1:m
                    sigma(1,pos_c)=sigma(1,pos_c)-CB(pos_tmp,1)*tmp_A(pos_tmp,pos_c);
                end
            end
            b
            CB
            c
            sigma
            tmp_A
            if max(sigma)>0
                flag=0;
                disp("??????");
                break;
            end
            min_sigma=99999999;
            %??sigma/y_(i,k)????????????????
            for i=1:n
                if i==min_b_pos
                    continue;
                end
                flag_ji=1;
                for j=1:m
                    if ji_x(j)==i
                        flag_ji=0;
                        break;
                    end
                end
                if flag_ji==1&&(tmp_A(min_b_pos_tmp,i)<0)
                    temp=(sigma(1,i)/tmp_A(min_b_pos_tmp,i)-0);
%                     if min_sigma<=temp||abs(round(min_sigma-temp)-(min_sigma-temp)) < 1e-3
                    if min_sigma>temp
                        min_sigma=temp;
                        min_sigma_pos=i;
                    end
                end
            end
            out_x_pos=min_b_pos%???
            in_x_pos=min_sigma_pos%???
            for in_out = 1:m
                if ji_x(in_out)==out_x_pos
                    ji_x(in_out)=in_x_pos;
                    CB(in_out,1)=c(in_x_pos);
                    break;
                end
            end
            %????????????????????????????????????????????????
            %???????????1
            tmp_beishu=tmp_A(in_out,ji_x(in_out));
            for change_1 =1:n
                tmp_A(in_out,change_1)=tmp_A(in_out,change_1)/tmp_beishu;
            end
            b(in_out,1)=b(in_out,1)/tmp_beishu;%???b???????
            %?????????
            for change_pos =1:m
                  if change_pos~=in_out%???????
                      beishu=tmp_A(change_pos,in_x_pos);
                      for tt=1:n%?????????
                          tmp_A(change_pos,tt)=tmp_A(change_pos,tt)-beishu*tmp_A(in_out,tt);
                      end
                      b(change_pos,1)=b(change_pos,1)-beishu*b(in_out,1);%????b??
                  end
            end
        end
        iter=iter+1;
    end
end
function [flag]=is_ones(a)%??????????
    flag=1;
    [row_a,col_a]=size(a);
    tmp_a=zeros(row_a);%????????1,????0???flag=flase;
    for i1 =1:row_a
        for j1 = 1:col_a
            if a(i1,j1)==1 && tmp_a(j1)==0
                tmp_a(j1)=1;
            elseif a(i1,j1)==0
                continue;
            else
                flag=0;
                break;
            end
        end
    end
    for i1 =1:row_a
        if tmp_a(i1)==0
            flag=0;
            break;
        end
    end
end

