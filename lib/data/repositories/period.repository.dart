import '../models/schema.dart';

class RecordRepository {
  FinancialPeriod getPeriod() {
    return FinancialPeriod(
      DateTime.now(),
      DateTime.now().add(const Duration(days: 30)),
      name: 'Mês de Maio',
      expense: [
        FinancialRecord('Aluguel', DateTime.now(), amount: 970.0),
        FinancialRecord('Internet', DateTime.now(), amount: 140.60),
        FinancialRecord('Energia', DateTime.now(), amount: 362.59),
        FinancialRecord(
          'Assinaturas',
          DateTime.now(),
          children: [
            FinancialRecord('Spotify', DateTime.now(), amount: 29.90),
            FinancialRecord('Netflix', DateTime.now(), amount: 45.90),
            FinancialRecord(
              'Twitch',
              DateTime.now(),
              children: [
                FinancialRecord('Prime', DateTime.now(), amount: 14.90),
                FinancialRecord('Pato Papão', DateTime.now(), amount: 9.90),
              ],
            ),
          ],
        ),
        FinancialRecord(
          'Viagem',
          DateTime.now(),
          children: [
            FinancialRecord(
              'Transporte',
              DateTime.now(),
              children: [
                FinancialRecord(
                  'Ônibus',
                  DateTime.now(),
                  children: [
                    FinancialRecord('Passagem', DateTime.now(), amount: 50.0),
                  ],
                ),
              ],
            ),
          ],
        ),
        FinancialRecord('Comida', DateTime.now(), amount: 11.23),
      ],
    );
  }
}
