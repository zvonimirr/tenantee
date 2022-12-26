type Nullable<T> = T | null;

type Id = string | number;

type Listable<T, P extends string> = {
    [key in P]: T[];
};

type Plural<T extends string> = 
    T extends 'property'
        ? 'properties'
        : `${T}s`;