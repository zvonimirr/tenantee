export interface Rent {
    due_date: string;
    id: number;
    paid: boolean;
}

export interface RentList {
    rents: Rent[];
}