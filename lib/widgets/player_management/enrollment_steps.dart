import 'package:flutter/material.dart';

class StepItem {
  final String id;
  final String name;

  StepItem({required this.id, required this.name});
}

class EnrollmentSteps extends StatelessWidget {
  final int currentStep;
  final List<StepItem> steps;

  const EnrollmentSteps({
    super.key,
    required this.currentStep,
    required this.steps,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Row(
        children: List.generate(steps.length, (index) {
          final isCompleted = index < currentStep;
          final isCurrent = index == currentStep;
          
          return Expanded(
            child: Row(
              children: [
                // Step Circle
                Column(
                  children: [
                    Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: isCompleted || isCurrent 
                            ? Theme.of(context).colorScheme.primary 
                            : Colors.transparent,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: isCompleted || isCurrent 
                              ? Theme.of(context).colorScheme.primary 
                              : Colors.grey.shade700,
                          width: 2,
                        ),
                      ),
                      child: isCompleted
                          ? const Icon(Icons.check, size: 18, color: Colors.white)
                          : Center(
                              child: isCurrent
                                  ? Container(
                                      width: 8,
                                      height: 8,
                                      decoration: const BoxDecoration(
                                        color: Colors.white,
                                        shape: BoxShape.circle,
                                      ),
                                    )
                                  : null,
                            ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      steps[index].name,
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: isCurrent ? FontWeight.bold : FontWeight.normal,
                        color: isCurrent || isCompleted 
                            ? Theme.of(context).colorScheme.onSurface 
                            : Colors.grey,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
                // Connector Line
                if (index != steps.length - 1)
                  Expanded(
                    child: Container(
                      height: 2,
                      margin: const EdgeInsets.only(bottom: 24), // Offset for text height
                      color: isCompleted 
                          ? Theme.of(context).colorScheme.primary 
                          : Colors.grey.shade800,
                    ),
                  ),
              ],
            ),
          );
        }),
      ),
    );
  }
}
