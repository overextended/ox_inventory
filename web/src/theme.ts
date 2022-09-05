import { createTheme } from '@mui/material';

// Theme colors
export let customTheme = createTheme({
  palette: {
    mode: 'dark',
    primary: {
      main: '#22232c',
      contrastText: '#C1C2C5',
    },
    secondary: {
      main: 'rgba(12, 12, 12, 0.4)',
      light: 'rgba(12, 12, 12, 0.8)',
      dark: 'rgba(0, 0, 0, 0.5)',
      contrastText: '#fff',
    },
  },
});

customTheme = createTheme({
  palette: { ...customTheme.palette },
  typography: { fontFamily: 'Roboto', fontSize: 12 },
  breakpoints: {
    values: {
      xs: 0,
      sm: 768,
      md: 900,
      lg: 1200,
      xl: 1536,
    },
  },
  components: {
    MuiTooltip: {
      styleOverrides: {
        tooltip: {
          backgroundColor: customTheme.palette.primary.main,
          minWidth: 200,
          color: customTheme.palette.primary.contrastText,
          borderRadius: 4,
          borderColor: 'rgba(0,0,0,0.2)',
          borderStyle: 'inset',
          borderWidth: 1,
        },
      },
    },
    MuiButton: {
      styleOverrides: {
        contained: {
          fontSize: 14,
          color: customTheme.palette.secondary.contrastText,
          backgroundColor: customTheme.palette.secondary.main,
          '&:hover': {
            backgroundColor: customTheme.palette.secondary.light,
          },
        },
      },
    },
    MuiInputBase: {
      styleOverrides: {
        root: {
          backgroundColor: customTheme.palette.secondary.main,
          color: customTheme.palette.secondary.contrastText,
          padding: 8,
          borderRadius: 4,
          fontSize: 16,
          transition: '200ms',
          '&:focus-within': {
            backgroundColor: customTheme.palette.secondary.light,
          },
        },
        input: {
          textAlign: 'center',
        },
      },
    },
    MuiDialogContent: {
      styleOverrides: {
        root: {
          backgroundColor: customTheme.palette.primary.main,
          color: customTheme.palette.primary.contrastText,
        },
      },
    },
    MuiDialogTitle: {
      styleOverrides: {
        root: {
          backgroundColor: customTheme.palette.primary.main,
          color: customTheme.palette.primary.contrastText,
        },
      },
    },
    MuiDialogActions: {
      styleOverrides: {
        root: {
          backgroundColor: customTheme.palette.primary.main,
          color: customTheme.palette.primary.contrastText,
        },
      },
    },
    MuiMenu: {
      styleOverrides: {
        list: {
          minWidth: 200,
          backgroundColor: customTheme.palette.primary.main,
          color: customTheme.palette.primary.contrastText,
          padding: '4px',
          borderColor: 'rgba(0,0,0,0.2)',
          borderStyle: 'inset',
          borderWidth: 1,
        },
      },
    },
    MuiMenuItem: {
      styleOverrides: {
        gutters: {
          padding: '4px 16px !important',
          fontSize: 16,
        },
      },
    },
  },
});
