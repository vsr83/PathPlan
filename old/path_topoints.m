% 26.7.2007
% path_topoints - Muuntaa solmujen v‰lisen liikeradan "aidoksi"
% liikeradaksi. 

% Tyyppi merkit‰‰n janan p‰‰tepisteeseen.

function Points = path_topoints(p, Mn, C, Path, Vout, E, V)

if nargin < 7
    [Vout, E, V] = visibilitygraph_polar(C);
end
    
n = inner_normal(p) * norm(p, 2);
[rows, cols] = size(Path);

Points = [Mn{Path(1)}.Point*[n;p] 1];

for ind_P = 1:length(Path)-1
    ind_next = ind_P + 1;
    curNode = Path(ind_P);
    nextNode = Path(ind_next);

    onZigzagSeg = (Mn{curNode}.Type == 1 && ...
                  (Mn{curNode}.Left == nextNode || ...
                   Mn{curNode}.Right == nextNode));
    onSegment = (Mn{curNode}.Polygon == Mn{nextNode}.Polygon && ...
                 Mn{curNode}.Segment == Mn{nextNode}.Segment);
     
    % Kuljemmeko siksak-janaa pitkin tai reunaa pitkin pysyen
    % samalla janalla?
    simple = onZigzagSeg || onSegment;
    
    jump = Path(ind_P, 2);
    if simple
        Points = [Points; Mn{nextNode}.Point*[n;p] onZigzagSeg+1];
    elseif jump%if 1 == 1
        startp = Mn{curNode};
        endp = Mn{nextNode};
        
        startp.Point = startp.Point * [n;p];
        endp.Point = endp.Point * [n;p];
        
        spath = shortestpath(startp, endp, C, Vout, E, V);
        %[curNode, nextNode]
        % Lyhimm‰n reitin alkusolmu on lis‰tty jo edellisell‰ ind_P.
        spath(1, :) = [];
        [rows, cols] = size(spath);
        Points = [Points; spath ones(rows, 1)*2+1];
    else
        Poly = C{Mn{curNode}.Polygon};
        [nSeg, tmp] = size(Poly);
        curSeg = Mn{curNode}.Segment;
        
        startp = Mn{curNode}.Point*[n;p];
        endp = Mn{nextNode}.Point*[n;p];
        
        posSeg = curSeg; negSeg = curSeg;
        Pointsp = []; Pointsn = [];        
        
        while posSeg ~= Mn{nextNode}.Segment
            posSeg = mod(posSeg, nSeg) + 1;
            if ~(posSeg == Mn{nextNode}.Segment && Mn{nextNode}.Type ~=1)
                Pointsp = [Pointsp;Poly(posSeg, :)];
            end
        end
        while negSeg ~= Mn{nextNode}.Segment
            if ~(negSeg == Mn{curNode}.Segment && Mn{curNode}.Type ~=1)
                Pointsn = [Pointsn;Poly(negSeg, :)];
            end
            negSeg = mod(negSeg-2, nSeg) + 1;
        end
        Pointsp = [Pointsp; endp];
        Pointsn = [Pointsn; endp];
        if polyc_length([startp; Pointsp]) > polyc_length([startp; Pointsn])
            [rows, tmp] = size(Pointsn);
            Points = [Points; Pointsn ones(rows, 1)];
        else
            [rows, tmp] = size(Pointsp);
            Points = [Points; Pointsp ones(rows, 1)];            
        end
        %{
        SO = segment_orientation(p, C{Mn{curNode}.Polygon}, Mn{curNode}.Segment);
        
        % Reunaa pitkin kulkiessamme selvit‰mme, tuleeko meid‰n
        % matkata positiiviseen vai negatiiviseen kulkusuuntaan.
        % T‰llaisessa liikkeess‰, emme siirry polygonilta toiselle, 
        % koska polygonien v‰linen liike on mahdollista vain siksak-
        % ja paluujanoja pitkin.
        
        Poly = C{Mn{curNode}.Polygon};
        [nSeg, tmp] = size(Poly);
        curSeg = Mn{curNode}.Segment;
                
        if Mn{curNode}.Type ~= 1
            prevSeg = mod(curSeg - 2 , nSeg) + 1;
            nextSeg = mod(curSeg, nSeg) + 1;
            nSu = unit(Poly(nextSeg, :) - Poly(curSeg, :));
            pSu = unit(Poly(prevSeg, :) - Poly(curSeg, :));
            pos = xor((nSu-pSu) * p' > 0, Mn{curNode}.Left == nextNode);
        else
            % L‰htiess‰mme tyypin 1 solmusta, nextNode on positiivisessa
            % kiertosuunnassa jos ja vain, jos SO > 0 && Up tai 
            % SO < 0 && Down.
            pos = ~xor(nextNode == Mn{curNode}.Up, SO > 0);
        end
            
        while curSeg ~= Mn{nextNode}.Segment                
            if pos
                curSeg = mod(curSeg, nSeg) + 1;
                if ~(curSeg == Mn{nextNode}.Segment && Mn{nextNode}.Type ~=1)
                    Points = [Points;Poly(curSeg, :) 1];
                    Poly(curSeg, :)
                end
            else
                if ~(curSeg == Mn{curNode}.Segment && Mn{curNode}.Type ~=1)
                    Points = [Points;Poly(curSeg, :) 1];
                end
                curSeg = mod(curSeg-2, nSeg) + 1;
            end
        end
        Points = [Points; Mn{nextNode}.Point*[n;p] 1];
        %}
    end
end