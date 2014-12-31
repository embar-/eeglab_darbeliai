% merge_cells()
%
% Programa lentelių sujungimui, panašias eilutes/stulpelius suguldant greta
%
% Naudojimas:
% Junginys = merge_cells(A, B, vardas_A, vardas_B, naudoti_stulpelius, antraštė_tik_pirmuose_stulpeliuose, antraštė_tik_pirmose_eilutėse)
%
%%
%
% Usage:
% Cell = merge_cells(A, B, name_A, name_B, add_collumn, common_only_from_start_x, common_only_from_start_y)
%
% A                        - cell
% B                        - cell
% name_A                   - number or string to identify A cell in new cell
% name_B                   - number or string to identify B cell in new cell
% add_collumn              - [0|1]; if 1 - different data makes growth in columns, not rows of cell (default 0).
% common_only_from_start_x - [0|1]; if 1 - check till first not equal column; if 0 - check all columns (default).
% common_only_from_start_y - [0|1]; if 1 - check till first not equal row; if 0 - check all rows (default).
%
%
%%
%
% (C) 2014 Mindaugas Baranauskas
%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Ši programa yra laisva. Jūs galite ją platinti ir/arba modifikuoti
% remdamiesi Free Software Foundation paskelbtomis GNU Bendrosios
% Viešosios licencijos sąlygomis: 2 licencijos versija, arba (savo
% nuožiūra) bet kuria vėlesne versija.
%
% Ši programa platinama su viltimi, kad ji bus naudinga, bet BE JOKIOS
% GARANTIJOS; be jokios numanomos PERKAMUMO ar TINKAMUMO KONKRETIEMS
% TIKSLAMS garantijos. Žiūrėkite GNU Bendrąją Viešąją licenciją norėdami
% sužinoti smulkmenas.
%
% Jūs turėjote kartu su šia programa gauti ir GNU Bendrosios Viešosios
% licencijos kopija; jei ne - rašykite Free Software Foundation, Inc., 59
% Temple Place - Suite 330, Boston, MA 02111-1307, USA.
%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% This program is free software; you can redistribute it and/or modify
% it under the terms of the GNU General Public License as published by
% the Free Software Foundation; either version 2 of the License, or
% (at your option) any later version.
%
% This program is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU General Public License for more details.
%
% You should have received a copy of the GNU General Public License
% along with this program; if not, write to the Free Software
% Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
%
%%

function C= merge_cells(A, B, varargin)

if ~iscell(A)
    if isnumeric(A) ;
        warning('Converting first variable to cell...');
        A=num2cell(A);
    else
        error('First variable is not cell.')
    end;
end;
if ~iscell(B)
    if isnumeric(B) ;
        warning('Converting second variable to cell...');
        B=num2cell(B);
    else
        error('Second variable is not cell.')
    end;
end;

if isempty(A);
    C=B;
    return;
end;
if isempty(B);
    C=A;
    return;
end;

if nargin > 2; name_A=varargin{1};
else           name_A=1;
end;
if nargin > 3; name_B=varargin{2};
else           name_B=2;
end;
if nargin > 4; add_collumn=varargin{3};
else           add_collumn=0;
end;
if nargin > 5; common_only_from_start_x=varargin{4};
else           common_only_from_start_x=0;
end;
if nargin > 6; common_only_from_start_y=varargin{5};
else           common_only_from_start_y=0;
end;
if and(isempty(name_A),isempty(name_B));
    use_identifier=0;
else
    use_identifier=1;
end;

common_x_i=[];
differ_x_i=[];
for i=1:min(size(A,2),size(B,2))
    if isequal(A(:,i),B(:,i));
        common_x_i=[common_x_i i ];
    else
        if common_only_from_start_x ;
            differ_x_i=[i:min(size(A,2),size(B,2))];
            break;
        else
            differ_x_i=[differ_x_i i ];
        end;
    end;
end;

common_y_i=[];
differ_y_i=[];
for i=1:min(size(A,1),size(B,1));
    if isequal(A(i,:),B(i,:));
        common_y_i=[common_y_i i ];
    else
        if common_only_from_start_y ;
            differ_y_i=[i:min(size(A,1),size(B,1))];
            break;
        else
            differ_y_i=[differ_y_i i ];
        end;
    end;
end;

if add_collumn ;
    
    C=[A(common_y_i,common_x_i) ; cell(1,length(common_x_i)) ; A(differ_y_i,common_x_i) ];
    
    if 1 == 1
        
        % old version
        for i=differ_x_i ;
            C=[C ...
                [ A(common_y_i,i) ; {name_A} ; A(differ_y_i,i)  ] ...
                [ B(common_y_i,i) ; {name_B} ; B(differ_y_i,i)  ] ];
        end;
        
        i= setdiff(1:size(A,2), 1:min(size(A,2),size(B,2)));
        if ~isempty(i);
            names={}; names(1,1:length(i))={name_A};
            C=[C    [ A(common_y_i,i) ;  names   ; A(differ_y_i,i)  ] ];
        end;
        
        i= setdiff(1:size(B,2), 1:min(size(A,2),size(B,2)));
        if ~isempty(i);
            names={}; names(1,1:length(i))={name_B};
            C=[C    [ B(common_y_i,i) ;  names   ; B(differ_y_i,i)  ] ];
        end;
        
    else
        % new version
        % not implemented for add_collumn=1
        % but it is implemented for add_collumn=0
    end;
else
    
    if use_identifier;
        name_A_={name_A};
        name_B_={name_B};
    else
        name_A_={};
        name_B_={};
    end;
    
    C=[A(common_y_i,common_x_i)  cell(length(common_y_i),use_identifier)  A(common_y_i,differ_x_i) ];
    
    if 1 == 0 % ~isempty(common_x_i);
        
        % old version
        
        for i=differ_y_i ;
            C=[C; ...
                A(i,common_x_i) name_A_ A(i,differ_x_i) ; ...
                B(i,common_x_i) name_B_ B(i,differ_x_i) ;];
        end;
        
        i= setdiff(1:size(A,1), 1:min(size(A,1),size(B,1)));
        if ~isempty(i);
            names={};
            if use_identifier ;
                names(1:length(i),1)={name_A};
            end;
            C=[C; A(i,common_x_i) names A(i,differ_x_i) ;];
        end;
        
        i= setdiff(1:size(B,1), 1:min(size(A,1),size(B,1)));
        if ~isempty(i);
            names={};
            if use_identifier ;
                names(1:length(i),1)={name_B};
            end;
            C=[C; B(i,common_x_i) names B(i,differ_x_i) ;];
        end;
        
    else
        % new version
        A_y_i=setdiff(1:size(A,1),common_y_i);
        B_y_i=setdiff(1:size(B,1),common_y_i);
        if isempty(common_x_i);
            c_x_i=1;
        else
            c_x_i=common_x_i;
        end;
        d_x_i=setdiff(differ_x_i,c_x_i);
        common_x1_v=intersect_cell_rows(A(A_y_i,c_x_i),B(B_y_i,c_x_i));
        if ~isempty(common_x1_v);
            for b=common_x1_v';
                i_A=find(ismember_cell_rows(A(A_y_i,c_x_i),b)==1);
                i_A=i_A+length(common_y_i);
                i_B=find(ismember_cell_rows(B(B_y_i,c_x_i),b)==1);
                i_B=i_B+length(common_y_i);
                
                names_A={};
                names_B={};
                if use_identifier ;
                    names_A(1:length(i_A),1)={name_A};
                    names_B(1:length(i_B),1)={name_B};
                end;
                
                C=[C; ...
                    A(i_A,c_x_i) names_A A(i_A,d_x_i) ; ...
                    B(i_B,c_x_i) names_B B(i_B,d_x_i) ;];
            end;
        end;
        
        
        
        i_A=find(ismember_cell_rows(A(A_y_i,c_x_i),common_x1_v)==0);
        i_A=i_A+length(common_y_i);
        i_B=find(ismember_cell_rows(B(B_y_i,c_x_i),common_x1_v)==0);
        i_B=i_B+length(common_y_i);
        
        
        names_A={};
        names_B={};
        if use_identifier ;
            names_A(1:length(i_A),1)={name_A};
            names_B(1:length(i_B),1)={name_B};
        end;
        
        C=[C; ...
            A(i_A,c_x_i) names_A A(i_A,d_x_i) ; ...
            B(i_B,c_x_i) names_B B(i_B,d_x_i) ;];
        
    end;
    
end ;


function C=intersect_cell_rows(A,B)
%% Find common between A and B
C={};
for i=1:size(A,1);
    for j=1:size(B,1);
        if isequal(A(i,:),B(j,:));
            C=[C ; A(i,:) ];
        end;
    end;
end;

% Find dublicates in C
dublicate_row_id=[];
for i=1:size(C,1);
    for j=(i+1):size(C,1);
        if isequal(C(i,:),C(j,:));
            dublicate_row_id=[dublicate_row_id j];
        end;
    end;
end;
% Result
C=C(setdiff(1:size(C,1),dublicate_row_id),:);


function idx=ismember_cell_rows(A,B)
%%
idx=[];
for i=1:size(A,1);
    t=0;
    for j=1:size(B,1);
        if ~t;
            if isequal(A(i,:),B(j,:));
                t=1;
            end;
        end;
    end;
    idx=[idx;t];
end;