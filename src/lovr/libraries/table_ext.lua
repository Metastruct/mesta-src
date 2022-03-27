local next = next
function table.IsEmpty(t)
	return next(t) == nil
end