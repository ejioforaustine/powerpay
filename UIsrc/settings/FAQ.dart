import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';

class Faq extends StatefulWidget {
  const Faq({Key? key}) : super(key: key);

  @override
  State<Faq> createState() => _FaqState();
}

class _FaqState extends State<Faq> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:ListView(children: [
        Row(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: const Icon(
                    Iconsax.arrow_left,
                    size: 40,
                  )),
            ),
            const SizedBox(
              width: 120,
            ),
            Expanded(
              child: Text(
                "FAQ'S",
                style: GoogleFonts.kadwa(
                    fontWeight: FontWeight.w900,
                    color: Colors.black,
                    fontSize: 25),
              ),
            ),
          ],
        ),
        ExpansionPanelList(
          elevation: 1,
          expandedHeaderPadding: EdgeInsets.zero,
          expansionCallback: (int index, bool isExpanded) {
            setState(() {
              faqs[index].isExpanded = !isExpanded;
            });
          },
          children: faqs.map<ExpansionPanel>((FAQ faq) {
            return ExpansionPanel(
              headerBuilder: (BuildContext context, bool isExpanded) {
                return ListTile(
                  title: Text(faq.question),
                );
              },
              body: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(faq.answer),
              ),
              isExpanded: faq.isExpanded,
            );
          }).toList(),
        )

      ],)
    );
  }
}

class FAQ {
  final String question;
  final String answer;
  bool isExpanded;

  FAQ({required this.question, required this.answer, this.isExpanded = false});
}
List<FAQ> faqs = [
  FAQ(
    question: 'Can I Buy/Pay For Electricity At Any Hour Of The Day?',
    answer: ' Ofcourse! The PowerPay platform is open 24/7. You can buy and pay for your electricity units anytime, anywhere.',
  ),
  FAQ(
    question: 'How do I get my Token?',
    answer: 'You will get your Token right after your payment process successfully, you will get an option to download a Receipt for your'
        ' Transaction after payment, Additionally your Token will be sent to your Email and Phone number you provided',
  ),

  FAQ(
    question: 'My USSD/Bank transfer Payment is still pending, what can i do ?',
    answer: 'This happens due to transfer delay from your bank or our receiving bank, contact our support team at whatsapp'
        ' +2348119543742, to resolve this quickly for you.',
  ),

  FAQ(
    question: 'I Was Debited For A Failed Transaction What Can I Do?',
    answer: 'Usually, you will receive a reversal from your bank within 24 hours. Contact our 24-hour support team on +234 8119543742 or send us an email at support@powerplug.ng if you don’t get a reversal.',
  ),

  FAQ(
    question: 'I do not Receive SMS and Email',
    answer: 'Chat with us on whatsapp '
        'Kindly contact our support team on +234 8119543742 or send us an email at support@powerpay.com',
  ),
  FAQ(
    question: 'What’s The NGN 100 Service Charge For?',
    answer: 'The service charge is required to make online transactions possible. '
        'It will be deducted from your total payment (assuming you made a payment of ₦7000 for Token, your meter will be credited with ₦6,900).'
        ,
  ),

  FAQ(
    question: 'I Cannot Load My Token?',
    answer: 'Here is a standard process you can follow: Ensure there is power supply in your area; '
        'Confirm the phase you are on has power supply; Put off generators and inverters and change over to power supply;'
        ' Key in the numbers you received as a token and Click on the “Enter” button. '
        'Kindly contact our support team on +234 8119543742 or send us an email at support@powerpay.com if you need more help',
  ),

  FAQ(
    question: 'My Meter Rejected The Token, What Can I Do?',
    answer: 'This could happen as a result of the following reasons:'
        ' The purchase was for the wrong meter number. Kindly confirm you are loading the token on the right meter. '
        'The meter has not yet been activated- An activation code will be required from the distribution company.'
        ' There has been a change in your tariff index.'
        ' Kindly contact our 24-hour support team on +2348119543742 or send us an email at support@powerpay.com.'
        ,
  ),

  FAQ(
    question: 'I Loaded The Token But Electricity Wasn’t Restored',
    answer: 'Ensure That You Input The Token Correctly.'
        ' Ensure there is power supply in your area; confirm the phase you are on has power supply.'
        ' A token can only be utilized by a specific meter number.'
        ' If your keypad displays used after you’ve entered the token, '
        'it simply means the token has already been loaded on the meter. '
        'Put off generators and inverters and do a change over to confirm power supply. '
        'This could also be as a result of technical Fault or loss of phase and Meter entering tamper mode.'
        ,
  ),

  FAQ(
    question: 'Can I Load The Token I Purchased On Another Meter?',
    answer: 'No. why?, Because a token is generated and encrypted using the unique ID of the meter, '
        'token generated can only be used by the specific meter.'
        ,
  ),

  FAQ(
    question: 'I Bought Token For The Wrong Meter',
    answer: 'A token is generated and encrypted using the unique ID of the prepaid meter number.'
        ' This is to ensure that the token generated can only be used by the specific meter number it was vended on.'
        ' You can only load the token digits for the meter number you purchased for.'
        ' Hence, please confirm your meter number before going ahead to confirm your payment'
        ,
  ),

  FAQ(
    question: 'The Number Of Unit I Got Was Lesser Than The Amount Purchased',
    answer: 'It could be as a result of the following There is a possibility a debt has been recorded on your meter, '
        'kindly check your token details for any debt deductions. If the previous payment was inclusive of free units. '
        'Kindly check your token details It could also mean your tariff plan has been changed, '
        'check with you distribution company '
        'Did you account for the transaction fee while making payment to recharge?'

    ,
  ),
  FAQ(
    question: 'Why Do I have Debt On My Meter?',
    answer: 'Debt on a meter can occur for several reasons The cost for the units on a newly installed meter is paid by the customer (as debt) on their first recharge of the meter'
        'Migration of Previous Debt If the property used an analog meter before the installation of a Prepaid meter, or using the estimated billing (Post Paid) and there was a debt before the installation of the prepaid meter, '
        'the debt on the estimated (Postpaid) billing account is migrated to the Prepaid meter account Penalties:'
        ' If there was a bypass or illegal connection discovered in the house, the penalty charge is added as debt to the prepaid meter account.'
        'Kindly visit the nearest electricity distribution company office to discuss your debt profile. As all meters are domiciled with them.'
    ,
  ),

  FAQ(
    question: 'I Bought The Same Amount For Two Different Meters But Got Different Units',
    answer: 'It could be as a result of the following: '
        'Prepaid meters are charged at different tariff rates (residential R1, commercial meter, industrial etc. are all charged differently.'
        ' If free units were included on the previous token purchase.'
        ' The tariff plan index has been changed.',
  ),
  FAQ(
    question: 'Can I Cancel A purchase On Power Plug And Get A Refund?',
    answer: 'A generated token can’t be cancelled or retreated, because it’s unique to your meter.'
        ' Kindly confirm your meter details before purchasing the token, it’s a final sale.'
        ' Kindly contact our 24-hour support team on +2348119543742 or send us an email at support@powerpay.com.'
    ,
  ),

  FAQ(
    question: 'What’s The Validity Date Of My Token?',
    answer: 'Validity period for a token is 3 months. However, '
        'Meters with series 021, 01011 have to load the first token generated before loading another token.'
    ,
  ),

  // Add more FAQ objects as needed
];
