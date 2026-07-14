# Embedded order
order_embedded = {'order_id':'o1','customer':'Alice','items':[{'sku':'p1','qty':2}]}
# Reference style
order_ref = {'order_id':'o2','customer':'Bob','item_ids':['i100','i101']}
print(order_embedded, order_ref)

#3.6 NoSQL Types — Column-Family Databases
graph = {'u1':['u2','u3'], 'u2':['u3'], 'u3':[]}
# friends of friends for u1
fof = set()
for friend in graph['u1']:
    fof.update(graph.get(friend, []))
print(fof - set(graph['u1']) - {'u1'})