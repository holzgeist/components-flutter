import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../../context/participant_context.dart';
import '../../context/track_reference_context.dart';
import '../../debug/logger.dart';
import '../builder/connection_quality_indicator.dart';
import '../builder/e2e_encryption_indicator.dart';
import '../builder/participant_muted_indicator.dart';
import '../builder/participant_name.dart';
import 'connection_quality_indicator.dart';

class ParticipantStatusBar extends StatelessWidget {
  const ParticipantStatusBar({
    super.key,
    this.showName = true,
    this.showE2EEStatus = true,
    this.showConnectionQuality = true,
    this.showMuteStatus = true,
  });

  final bool showName;
  final bool showE2EEStatus;
  final bool showConnectionQuality;
  final bool showMuteStatus;

  @override
  Widget build(BuildContext context) {
    return Consumer<ParticipantContext>(
      builder: (context, participantContext, child) {
        Debug.log(
            '===>     ParticipantStatusBar for ${participantContext.name}');
        var trackCtx = Provider.of<TrackReferenceContext?>(context);
        var isScreenShare = trackCtx?.isScreenShare ?? false;
        return Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 6),
            color: Colors.black.withOpacity(0.6),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  if (showMuteStatus && !isScreenShare)
                    ParticipantMutedIndicator(
                      builder: (context, isMuted) => isMuted
                          ? const Icon(
                              Icons.mic_off,
                              color: Colors.white54,
                              size: 20,
                            )
                          : const SizedBox(),
                    ),
                  if (isScreenShare)
                    const Icon(
                      Icons.screen_share,
                      color: Colors.white54,
                      size: 20,
                    ),
                  if (showName)
                    ParticipantName(
                      builder: (context, name) => name != null
                          ? Flexible(
                              child: Text(
                                isScreenShare ? '$name\'s screen' : name,
                                style: const TextStyle(
                                  color: Colors.white54,
                                  fontSize: 16,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            )
                          : Container(),
                    ),
                  if (showConnectionQuality)
                    ConnectionQualityIndicator(
                      builder: (context, connectionQuality) =>
                          ConnectionQualityIndicatorWidget(
                        connectionQuality: connectionQuality,
                      ),
                    ),
                  if (showE2EEStatus)
                    E2EEncryptionIndicator(
                      builder: (context, isEncrypted) => Padding(
                        padding: const EdgeInsets.only(left: 5),
                        child: Icon(
                          isEncrypted ? Icons.lock : Icons.lock_open,
                          color: Colors.white54,
                          size: 20,
                        ),
                      ),
                    ),
                ]),
          ),
        );
      },
    );
  }
}