% SHORTESTPATH etsii lyhimm‰n reitin kahden pisteen v‰lill‰.
%   points = SHORTESTPATH(startp, endp, C, Vout, E, V)
%
%   startp, endp ovat aloitus- ja MeshNode-rakenteita, jotka
%   vastaavat reitin aloitus- ja lopetuspisteit‰. Rakenteiden
%   aloitus- ja lopetuspisteet tulee olla alkuper‰isess‰ (ei np)
%   koordinaatistossa!
%
%   C on alueen polygonit m‰‰ritt‰v‰ cell array(kuten muuallakin).
%   Vout, E, V saadaan funktiolla VISIBILITYGRAPH_POLAR.
%
%   Funktio palauttaa nx2 matriisin, jonka rivit vastaavat lyhimm‰n
%   reitin pisteit‰.

function points = shortestpath(startp, endp, C, Vout, E, V)

tol = 0.0001;


[Vr, Vc] = size(V);
[Er, Ec] = size(E);

R = endp.Point - startp.Point;
angle = arctan(R(1), R(2));

if startp.Type == 1
    startVertex = Vr+1;
else
    startVertex = list_find(V, [startp.Polygon startp.Segment]);
end
if endp.Type == 1
    endVertex = Vr+2;
else
    endVertex = list_find(V, [endp.Polygon endp.Segment]);
end

% Lis‰t‰‰n n‰kyvyysgraafiin reittimme alku- ja loppupisteit‰
% vastaavat solmut.

V(Vr+1, :) = [startp.Polygon startp.Segment];
Vout(Vr+1, :) = [Vr+1 startp.Point];
V(Vr+2, :) = [endp.Polygon endp.Segment];
Vout(Vr+2, :) = [Vr+2 endp.Point];

% Tutkitaan onko meill‰ suora reitti pisteiden v‰lill‰.
% Reitti kahden tyypin 1 solmun v‰lill‰ on suora, jos niiden
% v‰lill‰ kulkeva jana on alueen sis‰puolella eik‰ leikkaa 
% yht‰‰n toista reunajanoista.

seginside = contour_isinside(C, 0.5*(endp.Point+startp.Point));

list = polyray_intersect(C, startp.Point, angle);
direct = (startp.Type == 1 && seginside && ...
         (length(list) == 0 || min(list(:, 3)) > norm(R, 2) - tol)) ...
         || (startp.Polygon == endp.Polygon && startp.Segment == endp.Segment);

if direct
    path = [startVertex endVertex]; %[Vr+1 Vr+2];
    dist = norm(R);
    points = [Vout(path, 2) Vout(path, 3)];
    disp 'Suora reitti'
    return;
end

% Jos aloituspiste ei ole polygonin k‰rkipiste, se tulee lis‰t‰
% n‰kyvyysgraafiin. T‰sm‰lleen sama operaatio t‰m‰n j‰lkeen tehd‰‰n
% lopetuspisteelle.

if startVertex > Vr
    
fangle_start = segment_findangle(C{startp.Polygon}, startp.Segment);
fangle_end   = fangle_start + pi;
visible_start = visiblevertices_polar(C, startp.Polygon, startp.Segment, ...
                                [startp.Point fangle_start fangle_end], 1);

[Visr, Visc] = size(visible_start);
for ind_V = 1:Visr
    vPoly =visible_start(ind_V, 1);
    vSeg = visible_start(ind_V, 2);

    vertex_source = Vr + 1;
    vertex_end = list_find(V, [vPoly vSeg]);

    if vertex_end > Vr
        continue;
    end
    
    m = min(vertex_source, vertex_end);
    M = max(vertex_source, vertex_end);
    
    if ~list_find(E, [m M])
        Er = Er + 1;
        E(Er, :) = [Er m M];
    end
end

end

if endVertex > Vr


    
fangle_start = segment_findangle(C{endp.Polygon}, endp.Segment);
fangle_end   = fangle_start + pi;
visible_end =  visiblevertices_polar(C, endp.Polygon, endp.Segment, ...
                                    [endp.Point fangle_start fangle_end], 1);
                        
[Visr, Visc] = size(visible_end);
for ind_V = 1:Visr
    vPoly =visible_end(ind_V, 1);
    vSeg = visible_end(ind_V, 2);

    vertex_source = Vr + 2;
    vertex_end = list_find(V, [vPoly vSeg]);

    if vertex_end > Vr
        continue;
    end    
    
    m = min(vertex_source, vertex_end);
    M = max(vertex_source, vertex_end);
    
    if ~list_find(E, [m M])
        Er = Er + 1;
        E(Er, :) = [Er m M];
    end
end

end

% Etsit‰‰n dijkstran algoritmilla lyhin reitti uudessa t‰ydennetyss‰
% n‰kyvyysgraafissa ja palautetaan solmuja vastaavien pisteiden
% koordinaatit.

[dist, path] = dijkstra(Vout, E, startVertex, endVertex);
%plot(Vout(path, 2), Vout(path, 3), 'g', 'LineWidth', 3);

points = [Vout(path, 2) Vout(path, 3)];