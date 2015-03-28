% function visible = visiblevertices_polar(C, sPoly, sVertex, draw)
%
% M‰‰ritt‰‰ polygonin k‰rjest‰ tai pisteest‰ n‰kyv‰t C:n polygonien
% k‰rjet.
%
% C on cell array polygoneja(nx2), joista negatiivisesti suunnistetut
% rajoittavat aluetta ulkopuolellensa ja positiivisesti suunnistetut
% sis‰puolellensa.
% sPoly on polygoni, jonka k‰rjen sVertex suhteen m‰‰rit‰mme
% n‰kyvyysgraafia. Jos Point ~= [], Point:ss‰ annetaan erillinen piste, 
% josta n‰kyv‰t k‰rjet m‰‰ritet‰‰n. Point on t‰llˆin muotoa 
% [x y fangle_start fangle_end], miss‰ x ja y m‰‰r‰‰v‰t pisteen
% koordinaatit sek‰ fangle_start, fangle_end kulmav‰lin jolta
% n‰kyvi‰ k‰rki‰ etsit‰‰n.
% Jos draw == 1, lˆydetyt n‰kyvyysgraafin k‰‰ret piirret‰‰n.
%
% Funktio palauttaa taulukon k.o pisteest‰ n‰kyvist‰ C:n polygonien
% k‰rjist‰ muodossa [poly1 vertex1;poly2 vertex2;...].
%
% HUOM!! Moninkertaiset pisteet polygonia kuvaavassa matriisissa
% voivat h‰irit‰ n‰kyvien k‰rkien lˆytymist‰.
%
% T‰ss‰ on oleellista huomioida, ettei funktio ainakaan yleens‰
% palauta janoja k‰rjist‰ viereisille k‰rjille, vaikka ne voidaan 
% tulkita  n‰kyviksi. Siisp‰ n‰kyvyysgraafialgoritmin on tarvittaessa
% lis‰tt‰v‰ ne erikseen.


function visible = visiblevertices_polar(C, sPoly, sVertex, Point, draw)

nPoly = length(C);
E = [];
events = [];
tol = 0.0001;

% Haetaan sallitut kulmat sek‰ l‰hdepiste:
if length(Point) == 0
    Poly = C{sPoly};
    [rows, tmp] = size(Poly);
    ind_prev = mod(sVertex-2, rows) + 1;
    ind_next = mod(sVertex, rows) + 1;
    p = Poly(sVertex, :);

    K = sisakulmat([Poly(ind_prev, :); Poly(sVertex, :); Poly(ind_next, :)]);

    R = Poly(ind_next, :) - Poly(sVertex, :);
    fangle_start = arctan(R(1), R(2));
    fangle_end = fangle_start + K(2);
    fangle_end = mod(fangle_end, 2*pi);
    visible = [sPoly ind_prev;sPoly ind_next];
else
    p = Point(1:2);
    fangle_start = Point(3);
    fangle_end = Point(4);
    fangle_end = mod(fangle_end, 2*pi);

    
    Poly = C{sPoly};
    [rows, tmp] = size(Poly);
    ind_next = mod(sVertex, rows) + 1;    
    
    visible = [sPoly sVertex; sPoly ind_next];
end

%T = bintree();

% K‰yd‰‰n C:n kaikki janat l‰pi. Jokaiseen janaan liitet‰‰n
% pienempi alkukulma(angle_start) ja suurempi loppukulma(angle_end)
% sek‰ vastaavat et‰isyydet.

LT = zeros(4096, 1);

for ind_P = 1:nPoly
    [nSeg, tmp] = size(C{ind_P});
    Poly = C{ind_P};
    
    for ind_S = 1:nSeg
        ind_next = mod(ind_S, nSeg) + 1;
        
        edge_start = Poly(ind_S, :) - p;
        edge_end   = Poly(ind_next, :) - p;
        
        angle_start = arctan(edge_start(1), edge_start(2));
        angle_end   = arctan(edge_end(1), edge_end(2));
        dist_start  = norm(edge_start, 2);
        dist_end    = norm(edge_end, 2);
        
        
        % Ylit‰mmekˆ p:n suhteen positiivisen x-akselin?
        if abs(angle_end - angle_start) > pi
            sw = true;
        else
            sw = false;
        end    
        
        % Jos arctan saa nollavektorin, se palauttaa negatiivisen
        % kulman. T‰ten emme voi leikata p:n viereisten reunojen
        % kanssa. Edelleen ei-toivotut leikkaukset n‰iden reunojen l‰pi
        % hyl‰t‰‰n kielt‰m‰ll‰ tietyt kulmat.
        if (angle_start < 0 || angle_end < 0) || ...
            (length(Point) == 4 && ind_S == sVertex && ind_P == sPoly)
            continue;
        end
        
        % Jos jana kiert‰‰ p:t‰ negatiiviseen kiertosuuntaan(myˆt‰-
        % p‰iv‰‰n), normaalisti angle_end < angle_start ja joudumme
        % vaihtamaan muuttujia kesken‰‰n.
        % Edelleen, jos ylit‰mme p:n suhteen positiivisen x-akselin
        % positiiviseen kiertosuuntaan, vastaava tilanne on toivottu.
        % Toisaalta negatiivisessa kiertosuunnassa vaihto on suoritettava.
        % Siisp‰
        swap_vertices = xor(angle_end < angle_start, sw);
        
        if swap_vertices
            tmp = dist_start;
            dist_start = dist_end;
            dist_end = tmp;
            tmp = angle_start;
            angle_start = angle_end;
            angle_end = tmp;
        end

        % E:hen listaamme C:n kaikki janat.
        E = [E;angle_start angle_end dist_start dist_end swap_vertices];
        [rows, cols] = size(E);

        % Tapahtumapistein‰ ovat janojen alku- ja loppupisteet
        % j‰rjestettyn‰ kulman mukaan, jonka ne luovat p-alkuisen
        % positiivisen x-akselin kanssa. T‰ss‰ on erityisen t‰rke‰‰
        % viitata oikean polygonin oikeaan k‰rkeen ja huomioida
        % aikaisemman "swappaamisen" vaikutus.
        if swap_vertices
            events = [events;angle_start, dist_start, rows, ind_P, ind_next; ...
                             angle_end, dist_end, rows, ind_P, ind_S];
        else
            events = [events;angle_start, dist_start, rows, ind_P, ind_S; ...
                             angle_end, dist_end, rows, ind_P, ind_next];
        end

        %s = sprintf('%d', rows);             
        %text(edge_start(1)+p(1), edge_start(2)+p(2), s);
        
        % Jos olemme ylitt‰neet p:n suhteen +x-akselin, leikkaa k.o
        % puolisuora t‰m‰nhetkist‰ janaa. Lis‰‰mme sen t‰ten 
        % k‰ytt‰m‰‰mme tietorakenteeseen.
        if sw
            LT(rows) = 1;
        end
    end
end

%plot(p(1), p(2), '^', 'MarkerSize', 10);

events = sortrows(events, [1 2]);
[nEvents, tmp] = size(events);

% Seuraavassa k‰ymme kaikki tapahtumapisteet l‰pi ja yll‰pid‰mme T:ss‰
% asianmukaisesti kirjaa niist‰ janoista, joita p-alkuinen puolisuora
% tapahtumapisteen suuntaan leikkaa. Jos tapahtumapiste on yht‰ l‰hell‰
% (tai l‰hemp‰n‰) kuin l‰hin kyseess‰olevista janoista lis‰‰mme
% n‰kyvyysgraafiin kaaren p:st‰ tapahtumapisteeseen.

for ind_E = 1:nEvents
    angle = events(ind_E, 1);
    ind   = events(ind_E, 3);
    ind_Poly = events(ind_E, 4);
    ind_Seg = events(ind_E, 5);
    
    a0 = E(ind, 1);
    a1 = E(ind, 2);
    dist0 = E(ind, 3);
    dist1 = E(ind, 4);
    swap_vertices = E(ind, 5);
    
    dist = min(dist0, dist1);
    
    % Kuuluuko tapahtumapisteen kulma k‰yp‰‰n joukkoon p:hen liittyvi‰
    % kulmia?
    feasible = ( (fangle_end > fangle_start) && ...
       (angle > fangle_start && angle < fangle_end)) || ...
       ( (fangle_end < fangle_start) && ...
       (angle > fangle_start || angle < fangle_end));
    
   % Jos kyseess‰ on janan alku kiertosuunnassa, lis‰‰mme sen T:hen. 
   % Muulloin kyseess‰ on janan loppu ja poistamme sen T:st‰.
   if angle == a0        
        LT(ind) = 1;
    elseif angle == a1
        LT(ind) = 0;
    end
    
    ind_F = find(LT);
        
    rmin = 20000;
    rs = [];
    
    % Selvit‰mme kuinka kaukana p:st‰ T:n janoja leikataan. T‰m‰ lienee
    % funktion ainoa kohta, jossa voi tapahtua huomioitavia numeerisia 
    % virheit‰.
    for ind_IF = 1:length(ind_F)
        ind_T = ind_F(ind_IF);
        [x, y] = segments_intersection([0 0], 4000*[cos(angle) sin(angle)], ...
                     E(ind_T,3)* [cos(E(ind_T,1)) sin(E(ind_T,1))], ...
                     E(ind_T,4)* [cos(E(ind_T,2)) sin(E(ind_T,2))]);
        
        r = norm([x, y], 2);
        if r < rmin
            rmin = r;            
        end
    end
    
    if feasible 
        if angle == a0 && dist0 <= rmin+tol
            if draw
                plot([p(1);p(1)+cos(angle)*dist0], [p(2);p(2)+sin(angle)*dist0], 'r');
            end
            visible = list_insert(visible, [ind_Poly ind_Seg]);
        elseif angle == a1 && dist1 <= rmin+tol
            if draw
                plot([p(1);p(1)+cos(angle)*dist1], [p(2);p(2)+sin(angle)*dist1], 'r');
            end
            visible = list_insert(visible, [ind_Poly ind_Seg]);
        end
    end
    if draw == 2
        ind_F
    end
end
