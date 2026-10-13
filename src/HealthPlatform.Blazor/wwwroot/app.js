window.healthTheme = {
    get: () => window.localStorage.getItem("health-theme-dark"),
    set: value => window.localStorage.setItem("health-theme-dark", value)
};
