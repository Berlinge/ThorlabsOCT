function [a_scan_all] = cast2uint8(a_scan_all)
% Cast to uint8
a_scan_all = abs(a_scan_all);
a_scan_all(isinf(a_scan_all)) = 0;
if (min(a_scan_all,[],'all')) < 0
    a_scan_all = a_scan_all+abs(min(a_scan_all,[],'all'));
end
a_scan_all = uint8(a_scan_all.*(255./max(a_scan_all,[],'all')));
end