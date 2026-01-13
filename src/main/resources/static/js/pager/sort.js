document.addEventListener("DOMContentLoaded", function() {
    updateSortIcons();
});

function updateSortIcons() {
    const urlParams = new URLSearchParams(window.location.search);

    document.querySelectorAll('.sort-icon').forEach(icon => {
        icon.className = 'bx bx-sort-alt-2 sort-icon';
        icon.style.color = '#ccc';
    });

    let i = 0;
    while (urlParams.has(`sortConditions[${i}].field`)) {
        const field = urlParams.get(`sortConditions[${i}].field`);
        const dir = urlParams.get(`sortConditions[${i}].dir`);

        const targetIcon = document.getElementById('icon_' + field);
        if (targetIcon) {
            if (dir === 'ASC') {
                targetIcon.className = 'bx bx-sort-up sort-icon';
            } else {
                targetIcon.className = 'bx bx-sort-down sort-icon';
            }
            targetIcon.style.color = '#696cff';
        }

        i++;
    }
}

function moveSort(field) {
    const currentParams = new URLSearchParams(window.location.search);

    let sorts = [];
    let i = 0;
    while (currentParams.has(`sortConditions[${i}].field`)) {
        sorts.push({
            field: currentParams.get(`sortConditions[${i}].field`),
            dir: currentParams.get(`sortConditions[${i}].dir`)
        });
        i++;
    }

    const existingIndex = sorts.findIndex(s => s.field === field);
    if (existingIndex !== -1) {
        if (sorts[existingIndex].dir === 'ASC') {
            sorts[existingIndex].dir = 'DESC';
        } else {
            sorts.splice(existingIndex, 1);
        }
    } else {
        sorts.push({ field: field, dir: 'ASC' });
    }

    const newParams = new URLSearchParams();

    for (const [key, value] of currentParams) {
        if (!key.startsWith('sortConditions') && key !== 'page') {
            newParams.append(key, value);
        }
    }

    sorts.forEach((sort, index) => {
        newParams.append(`sortConditions[${index}].field`, sort.field);
        newParams.append(`sortConditions[${index}].dir`, sort.dir);
    });

    newParams.set('page', 1);
    location.href = location.pathname + '?' + newParams.toString();
}