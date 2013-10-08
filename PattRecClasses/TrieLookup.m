function [t, node] = TrieLookup(word, t)
    
    node = 1; % Root node
    for char = word
        children = t.getchildren(node);
        child_chars = arrayfun(@t.get, children, 'UniformOutput', false);
        next_index = find(ismember(child_chars, char));
        if (next_index)
            node = children(next_index);
        else
            [t, node] = t.addnode(node, char);
        end
    end
    
end