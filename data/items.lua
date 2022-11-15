return {
    ['bandage'] = {
        label = 'Bandage',
        weight = 115,
        client = {
            anim = { dict = 'missheistdockssetup1clipboard@idle_a', clip = 'idle_a', flag = 49 },
            prop = { model = `prop_rolled_sock_02`, pos = vec3(-0.14, -0.14, -0.08), rot = vec3(-50.0, -50.0, 0.0) },
            disable = { move = true, car = true, combat = true },
            usetime = 2500,
        }
    },

    ['black_money'] = {
        label = 'Argent sale',
    },

    ['parachute'] = {
        label = 'Parachute',
        weight = 8000,
        stack = false,
        client = {
            anim = { dict = 'clothingshirt', clip = 'try_shirt_positive_d' },
            usetime = 1500
        }
    },

    ['lockpick'] = {
        label = 'Lockpick',
        weight = 160,
        consume = 1,
        client = {
            export = "ceeb_vehiclekey.lockpick"
        }
    },

    ['phone'] = {
        label = 'Téléphone',
        weight = 190,
        stack = false,
        consume = 0,
        client = {
            event = "ox_inventory:checkSIM",
        },
        buttons = {
            {
                label = "Voir l'interieur",
                action = function(slot)
                    openSIM(slot)
                end
            },
        }
    },

    ['money'] = {
        label = 'Money',
    },

    ['radio'] = {
        label = 'Radio',
        weight = 100,
        stack = true,
        close = true,
        client = {
            export = 'ac_radio.openRadio',
            remove = function(total)
                -- Disconnets a player from the radio when all his radio items are removed.
                if total < 1 and GetConvar('radio_noRadioDisconnect', 'true') == 'true' then
                    exports.ac_radio:leaveRadio()
                end
            end
        }
    },

    ['armour'] = {
        label = 'Gilet pare-balles',
        weight = 3000,
        stack = false,
        consume = 1,
        client = {
            event = "ceeb_shieldshop:use",
            anim = { dict = 'clothingshirt', clip = 'try_shirt_positive_d' },
            usetime = 3500
        }
    },

    ['mask'] = {
        label = 'Masque',
        weight = 150,
        stack = false,
        consume = 1,
        client = {
            event = "ceeb_maskshop:use",
            anim = { dict = 'clothingshirt', clip = 'try_shirt_positive_d' },
            usetime = 1500
        }
    },

    ['hat'] = {
        label = 'Chapeau / Casque',
        weight = 150,
        stack = false,
        consume = 1,
        client = {
            event = "ceeb_hatshop:use",
            anim = { dict = 'clothingshirt', clip = 'try_shirt_positive_d' },
            usetime = 1500
        }
    },

    ['cannabis'] = {
        label = 'cannabis',
        weight = 0.07,
        stack = true,
        close = true,
        description = nil
    },

    ['cubancigar'] = {
        label = 'cigare cubain',
        weight = 0.02,
        stack = true,
        close = true,
        description = nil
    },

    ['davidoffcigar'] = {
        label = 'cigare davidoff',
        weight = 0.02,
        stack = true,
        close = true,
        description = nil
    },

    ['defibrilator'] = {
        label = 'defibrilateur',
        weight = 2.5,
        stack = true,
        close = true,
        description = nil
    },

    ['fixtool'] = {
        label = 'outils de réparations',
        weight = 4.2,
        stack = true,
        close = true,
        consume = 1,
        client = {
            event = "ceeb_repairkit:doRepair",
        }
    },

    ['lighter'] = {
        label = 'briquet',
        weight = 0.03,
        stack = true,
        close = true,
        description = nil
    },

    ['marijuana'] = {
        label = 'marijuana',
        weight = 0.09,
        stack = true,
        close = true,
        description = nil,
        client = {
            export = "devcore_smoke.Crollingpaper",
            usetime = 1500
        }
    },

    ['marlboro'] = {
        label = 'paquet de marlbarey ',
        weight = 0.04,
        stack = true,
        close = true,
        description = nil
    },

    ['marlborocig'] = {
        label = 'cigarette marlbarey',
        weight = 0.01,
        stack = true,
        close = true,
        description = nil
    },

    ['handcuff'] = {
        label = 'menottes',
        weight = 0.3,
        stack = true,
        close = true,
        description = nil
    },

    ['coke_pooch'] = {
        label = 'pochon de coke',
        weight = 0.02,
        stack = true,
        close = true,
        description = nil
    },

    ['coca_leaf'] = {
        label = 'feuille de coca',
        weight = 0.01,
        stack = true,
        close = true,
        description = nil
    },

    ['weed_seed'] = {
        label = 'graine de weed',
        weight = 0.01,
        stack = true,
        close = true,
        description = nil
    },

    ['weed_fertilizer'] = {
        label = 'engrais',
        weight = 0.9,
        stack = true,
        close = true,
        description = nil
    },

    ['coca_seed'] = {
        label = 'graine de coca',
        weight = 0.01,
        stack = true,
        close = true,
        description = nil
    },

    ['illegal_medical_pass'] = {
        label = 'pass médical illégal',
        weight = 0.02,
        stack = true,
        close = true,
        description = nil
    },

    ['spike'] = {
        label = 'herse',
        weight = 3,
        stack = true,
        close = true,
        description = nil
    },

    ['jumelles'] = {
        label = 'jumelles',
        weight = 0,
        stack = true,
        close = true,
        description = nil
    },

    ['pochon'] = {
        label = 'pochon vide',
        weight = 0.02,
        stack = true,
        close = true,
        description = nil
    },

    ['timerbomb'] = {
        label = 'bombe à retardement',
        weight = 5,
        stack = true,
        close = true,
        description = nil
    },

    ['speedbomb'] = {
        label = 'bombe à vitesse max',
        weight = 5,
        stack = true,
        close = true,
        description = nil
    },

    ['remotebomb'] = {
        label = 'bombe télécommandée',
        weight = 5,
        stack = true,
        close = true,
        description = nil
    },

    ['instantbomb'] = {
        label = 'bombe instantannée',
        weight = 5,
        stack = true,
        close = true,
        description = nil
    },

    ['cv_repas'] = {
        label = 'repas',
        weight = 1,
        stack = true,
        close = true,
        description = nil
    },

    ['cv_boisson'] = {
        label = 'boisson',
        weight = 1,
        stack = true,
        close = true,
        description = nil
    },

    ['sim'] = {
        label = 'Carte SIM',
        weight = 0.02,
        stack = true,
        close = true,
        description = nil
    },

    ['braceletgps'] = {
        label = 'bracelet gps actif',
        weight = 1,
        stack = true,
        close = true,
        description = nil
    },

    ['braceletgps_off'] = {
        label = 'bracelet gps inactif',
        weight = 1,
        stack = true,
        close = true,
        description = nil
    },

    ['coupebracelet'] = {
        label = 'pince coupante',
        weight = 1,
        stack = true,
        close = true,
        description = nil
    },

    ['screwdriver'] = {
        client = {
            event = "ceeb_platechanger:changeplate"
        },
        label = 'tournevis',
        weight = 0.2,
        stack = true,
        close = true,
        description = nil
    },

    ['fakeplate'] = {
        label = 'fausse plaque',
        weight = 0.2,
        stack = true,
        close = true,
        description = nil
    },

    ['briefcasemoney'] = {
        label = 'Valise d\'argent fermée',
        weight = 3.36,
        stack = true,
        close = true,
        description = nil
    },

    ['fishingrod'] = {
        label = 'Canne a peche',
        weight = 3.36,
        stack = true,
        close = true,
        description = nil
    },

    ['bait'] = {
        label = 'Appât',
        weight = 0.30,
        stack = true,
        close = true,
        description = nil
    },

    ['mastercard'] = {
        label = 'Mastercard',
        stack = false,
        weight = 10,
    },

    ["nos"] = {
        label = "Bouteille de NOS",
        weight = 2000,
        stack = false,
        close = true,
        client = {
            disable = { move = true, car = true, combat = true },
            usetime = 3500,
            cancel = true,
            export = "ND_Nitro.nos"
        }
    },
    ['ocb_paper'] = {
        label = 'Feuille OCB slim',
        stack = true,
        weight = 10,
        close = true,
        client = {
            export = "devcore_smoke.Crollingpaper",
            usetime = 1500
        }
    },
}
