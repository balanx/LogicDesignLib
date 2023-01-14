
import sympy as sym

def vector(n, ch, order=True) : # True is 0,1,2, ...
    vec = []
    s = range(n)
    if not order :
        s = reversed(s)
    for i in s :
        vec.append(sym.Symbol(ch + '['+str(i)+']'))

    return sym.Matrix(vec)


def mat_G_T(s) :
    G = []
    i = -1
    for ch in s :
        if ch == '0' or ch == '1' :
            G.append(int(ch))
            i += 1

    G = sym.Matrix(G)

    T = sym.eye(i)
    T = T.row_insert(i, sym.zeros(1, i))
    T = T.col_insert(0, G)

    return i+1, G, T


def bin_simp(expr, x) :
    co = expr.coeff(x)
    if co > 1 :
        expr -= co * x
        if co % 2 :
            expr += x

    return expr

def vec_simp(vec, C, D) :
    for i,yy in enumerate(vec):
        for j,cc in enumerate(C):
            yy = bin_simp(yy, cc)
        for j,dd in enumerate(D):
            yy = bin_simp(yy, dd)

        vec[i] = yy


def lfsr_parallel(g, w) :
    n,G,T = mat_G_T(g)
    C0 = vector(n, 'c', False)
    Ci = C0
    Y = vector(n, 'y', False)
    D = vector(w, 'd', False)

    for i,element in enumerate(D):
        Y  = T*Ci + G*element
        Ci = Y
        #print(element)
        #input()

    vec_simp(Y, C0, D)
    return Y



if __name__ == '__main__' :

    g = '0000-0100-1100-0001-0001-1101-1011-0111'  # CRC-32 = 0x04C11DB7
    #g = '0001-0000-0010-0001'  # CRC-16 = 0x1021
    #g = '1101-0101'  # CRC-8 = 0xD5
    #g = '011'  # CRC-3 = 0x3

    Y = lfsr_parallel(g, 8)

    #print('====')
    for i,element in enumerate(Y):
        print('Y['+str(i)+'] =', element)


