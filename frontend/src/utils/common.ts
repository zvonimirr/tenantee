export function pluralize<T>(
    items: T[],
    singular: string,
    plural?: string,
): string {
    if (!plural) {
        plural = singular + 's';
    }
    return items.length === 1 ? singular : plural;
}
