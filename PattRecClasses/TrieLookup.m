function [t, nodes] = TrieLookup(word, t)
    
    nodes = zeros(size(word));
    node = 1; % Root node
    i = 0;
    for char = word
        i = i + 1;
        children = t.getchildren(node);
        child_chars = arrayfun(@t.get, children, 'UniformOutput', false);
        next_index = find(ismember(child_chars, char));
        if (next_index)
            node = children(next_index);
        else
            [t, node] = t.addnode(node, char);
        end
        nodes(i) = node;
    end
    
end