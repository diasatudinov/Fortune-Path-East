// MARK: - Session Setup

struct SessionSetupView: View {
    @EnvironmentObject private var store: AppStore

    @State private var startingBalance = "500"
    @State private var stopLoss = "50"
    @State private var takeProfit = "100"
    @State private var durationMinutes = 30
    @State private var showLiveTracker = false

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 16) {
                    EastCard {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Boundaries of the Path")
                                .font(.title2.bold())

                            Text("Before entering the river, know its shores.")
                                .foregroundStyle(.secondary)
                        }.foregroundStyle(.white)
                    }

                    SetupField(
                        title: "Starting Balance",
                        subtitle: "Your current reserve",
                        text: $startingBalance
                    )

                    SetupField(
                        title: "Yin — Stop-Loss",
                        subtitle: "Amount you are ready to give to the river",
                        text: $stopLoss
                    )

                    SetupField(
                        title: "Yang — Take-Profit",
                        subtitle: "Profit goal where you leave with gratitude",
                        text: $takeProfit
                    )

                    EastCard {
                        Stepper(
                            "Session Time: \(durationMinutes) min",
                            value: $durationMinutes,
                            in: 5...180,
                            step: 5
                        )
                        .foregroundStyle(.white)
                    }

                    if store.currentSession != nil {
                        Button {
                            showLiveTracker = true
                        } label: {
                            Label("Continue Current Path", systemImage: "play.fill")
                                .font(.headline)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(AppTheme.gold)
                                .foregroundStyle(.black)
                                .clipShape(RoundedRectangle(cornerRadius: 16))
                        }
                    }

                    Button {
                        guard let settings else { return }
                        store.startSession(settings: settings)
                        showLiveTracker = true
                    } label: {
                        Label("Enter the Flow", systemImage: "water.waves")
                            .font(.headline)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(settings == nil ? Color.gray : AppTheme.jade)
                            .foregroundStyle(.white)
                            .clipShape(RoundedRectangle(cornerRadius: 16))
                    }
                    .disabled(settings == nil)
                }
                .padding()
            }
            .navigationTitle("Path Setup")
            .background(AppTheme.background.ignoresSafeArea())
            .navigationDestination(isPresented: $showLiveTracker) {
                LiveTrackerView()
            }
        }
    }

    private var settings: SessionSettings? {
        guard
            let start = Double.fromInput(startingBalance),
            let loss = Double.fromInput(stopLoss),
            let profit = Double.fromInput(takeProfit),
            start >= 0,
            loss > 0,
            profit > 0
        else {
            return nil
        }

        return SessionSettings(
            startingBalance: start,
            stopLoss: loss,
            takeProfit: profit,
            durationMinutes: durationMinutes
        )
    }
}

struct SetupField: View {
    let title: String
    let subtitle: String
    @Binding var text: String

    var body: some View {
        EastCard {
            VStack(alignment: .leading, spacing: 8) {
                Text(title)
                    .font(.headline)
                    .foregroundStyle(.white)
                Text(subtitle)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .foregroundStyle(.white)
                
                TextField("0", text: $text)
                    .keyboardType(.decimalPad)
                    .textFieldStyle(.roundedBorder)
                    .foregroundStyle(.black)
            }
        }
    }
}